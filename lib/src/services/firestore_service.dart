import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import '../models/account.dart';
import '../models/contact.dart';
import '../models/friend_loan.dart';
import '../models/loan_event.dart';
import '../models/member.dart';
import '../models/transaction.dart';

class FirestoreService {
  FirestoreService(this._firestore, this._dynamicLinks);

  final FirebaseFirestore _firestore;
  final FirebaseDynamicLinks _dynamicLinks;

  // Collections
  CollectionReference<Map<String, dynamic>> get _accounts => _firestore.collection('accounts');

  CollectionReference<Map<String, dynamic>> _transactions(String accountId) =>
      _accounts.doc(accountId).collection('transactions');

  CollectionReference<Map<String, dynamic>> _contacts(String accountId) =>
      _accounts.doc(accountId).collection('contacts');

  CollectionReference<Map<String, dynamic>> _loans(String accountId) =>
      _accounts.doc(accountId).collection('loans');

  DocumentReference<Map<String, dynamic>> _loanDoc(String accountId, String loanId) =>
      _loans(accountId).doc(loanId);

  // ==================== ACCOUNT METHODS ====================

  Future<Account> createAccount(Account account) async {
    final doc = _accounts.doc();
    final payload = account.copyWith(id: doc.id);
    final json = payload.toJson();
    json['members'] = payload.members.map((m) => m.toJson()).toList();
    await doc.set(json);
    return payload;
  }

  Future<void> updateAccount(Account account) {
    final json = account.toJson();
    json['members'] = account.members.map((m) => m.toJson()).toList();
    return _accounts.doc(account.id).update(json);
  }

  Future<void> deleteAccount(String accountId) async {
    await _accounts.doc(accountId).delete();
  }

  Stream<List<Account>> watchAccountsForUser(String uid) {
    return _accounts.where('memberUids', arrayContains: uid).snapshots().map((snapshot) {
      final accounts = snapshot.docs.map((doc) => Account.fromJson({...doc.data(), 'id': doc.id})).toList();
      // Sort in memory to avoid composite index requirement
      accounts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return accounts;
    });
  }

  Stream<Account?> watchAccount(String accountId) {
    if (accountId.isEmpty) return const Stream<Account?>.empty();
    return _accounts.doc(accountId).snapshots().map((snapshot) {
      final data = snapshot.data();
      if (data == null) return null;
      return Account.fromJson({...data, 'id': snapshot.id});
    });
  }

  // ==================== TRANSACTION METHODS ====================

  Stream<List<AccountTransaction>> watchTransactions(String accountId) {
    return _transactions(accountId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => AccountTransaction.fromJson({...doc.data(), 'id': doc.id})).toList());
  }

  Stream<List<AccountTransaction>> watchPendingTransactions(String accountId) {
    return _transactions(accountId)
        .where('dueDate', isNotEqualTo: null)
        .where('isPaid', isEqualTo: false)
        .orderBy('dueDate')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => AccountTransaction.fromJson({...doc.data(), 'id': doc.id})).toList());
  }

  Stream<List<AccountTransaction>> watchOverdueTransactions(String accountId) {
    final now = DateTime.now();
    return _transactions(accountId)
        .where('isPaid', isEqualTo: false)
        .where('dueDate', isLessThan: now)
        .orderBy('dueDate')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => AccountTransaction.fromJson({...doc.data(), 'id': doc.id})).toList());
  }

  Future<void> addTransaction(AccountTransaction transaction) async {
    final doc = _transactions(transaction.accountId).doc();
    final payload = transaction.copyWith(id: doc.id);
    await doc.set(payload.toJson());

    // Update account totals
    final accountRef = _accounts.doc(transaction.accountId);
    await _firestore.runTransaction((txn) async {
      final accountDoc = await txn.get(accountRef);
      if (!accountDoc.exists) return;

      final data = accountDoc.data()!;
      final totalIn = (data['totalIn'] ?? 0.0) + (transaction.type == TransactionType.cashIn ? transaction.amount : 0);
      final totalOut = (data['totalOut'] ?? 0.0) + (transaction.type == TransactionType.cashOut ? transaction.amount : 0);

      txn.update(accountRef, {'totalIn': totalIn, 'totalOut': totalOut});
    });
  }

  Future<void> updateTransaction(AccountTransaction transaction) {
    return _transactions(transaction.accountId).doc(transaction.id).update(transaction.toJson());
  }

  Future<void> markTransactionAsPaid(String accountId, String transactionId) {
    return _transactions(accountId).doc(transactionId).update({
      'isPaid': true,
      'paidAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteTransaction(String accountId, String transactionId) {
    return _transactions(accountId).doc(transactionId).delete();
  }

  // ==================== CONTACT METHODS ====================

  Stream<List<Contact>> watchContacts(String accountId) {
    return _contacts(accountId)
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Contact.fromJson({...doc.data(), 'id': doc.id})).toList());
  }

  Future<void> upsertContact(Contact contact) {
    final collection = _contacts(contact.accountId);
    final doc = contact.id.isEmpty ? collection.doc() : collection.doc(contact.id);
    final payload = contact.copyWith(id: doc.id);
    return doc.set(payload.toJson());
  }

  Future<void> deleteContact(String accountId, String contactId) {
    return _contacts(accountId).doc(contactId).delete();
  }

  // ==================== LOAN METHODS ====================

  Stream<List<FriendLoan>> watchLoans(String accountId) {
    return _loans(accountId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => FriendLoan.fromJson({...doc.data(), 'id': doc.id})).toList());
  }

  Future<FriendLoan> createLoan(FriendLoan loan) async {
    final doc = _loans(loan.accountId).doc();
    final payload = loan.copyWith(
      id: doc.id,
      createdAt: loan.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await doc.set(payload.toJson());
    return payload;
  }

  Stream<List<LoanEvent>> watchLoanEvents(String accountId, String loanId) {
    return _loanDoc(accountId, loanId)
        .collection('events')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => LoanEvent.fromJson({...doc.data(), 'id': doc.id})).toList());
  }

  Future<void> addLoanEvent(String accountId, String loanId, LoanEvent event) async {
    final loanRef = _loanDoc(accountId, loanId);
    final eventRef = loanRef.collection('events').doc();
    await eventRef.set(event.copyWith(id: eventRef.id).toJson());
    await _updateLoanTotals(loanRef, event);
  }

  Future<void> settleLoan(String accountId, String loanId) async {
    final loanRef = _loanDoc(accountId, loanId);
    await loanRef.update({
      'net': 0,
      'totalYouGave': 0,
      'totalYouTook': 0,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _updateLoanTotals(DocumentReference<Map<String, dynamic>> loanRef, LoanEvent event) {
    return _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(loanRef);
      final data = snapshot.data() ?? {};
      var totalYouGave = (data['totalYouGave'] ?? 0).toDouble();
      var totalYouTook = (data['totalYouTook'] ?? 0).toDouble();

      switch (event.type) {
        case LoanEventType.youLent:
          totalYouGave += event.amount;
          break;
        case LoanEventType.youBorrowed:
          totalYouTook += event.amount;
          break;
        case LoanEventType.repayment:
          totalYouTook -= event.amount;
          break;
        case LoanEventType.settlement:
          totalYouGave = 0;
          totalYouTook = 0;
          break;
      }

      final net = totalYouGave - totalYouTook;
      transaction.update(loanRef, {
        'totalYouGave': totalYouGave,
        'totalYouTook': totalYouTook,
        'net': net,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  // ==================== MEMBER METHODS ====================

  Future<void> addMember(String accountId, String memberUid, MemberRole role) {
    final doc = _accounts.doc(accountId);
    return doc.update({
      'members': FieldValue.arrayUnion([AccountMember(uid: memberUid, role: role).toJson()]),
      'memberUids': FieldValue.arrayUnion([memberUid]),
    });
  }

  Future<void> removeMember(String accountId, String memberUid) {
    final doc = _accounts.doc(accountId);
    return _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(doc);
      final data = snapshot.data() ?? {};
      final members = (data['members'] as List<dynamic>? ?? [])
          .map((m) => AccountMember.fromJson(Map<String, dynamic>.from(m as Map<dynamic, dynamic>)))
          .where((member) => member.uid != memberUid)
          .map((member) => member.toJson())
          .toList();
      final memberUids = (data['memberUids'] as List<dynamic>? ?? []).where((id) => id != memberUid).toList();
      transaction.update(doc, {
        'members': members,
        'memberUids': memberUids,
      });
    });
  }

  Future<void> updateMemberRole(String accountId, String memberUid, MemberRole newRole) {
    final doc = _accounts.doc(accountId);
    return _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(doc);
      final data = snapshot.data() ?? {};
      final members = (data['members'] as List<dynamic>? ?? [])
          .map((m) => AccountMember.fromJson(Map<String, dynamic>.from(m as Map<dynamic, dynamic>)))
          .map((member) => member.uid == memberUid ? member.copyWith(role: newRole) : member)
          .map((member) => member.toJson())
          .toList();
      transaction.update(doc, {'members': members});
    });
  }

  // ==================== INVITE LINK ====================

  Future<String> generateInviteLink(String accountId) async {
    final link = await _dynamicLinks.buildLink(
      DynamicLinkParameters(
        link: Uri.parse('https://cashflowx.app.link/invite?account=$accountId'),
        uriPrefix: 'https://cashflowx.app.link',
        androidParameters: const AndroidParameters(packageName: 'com.abrar.cashflowx'),
        iosParameters: const IOSParameters(bundleId: 'com.abrar.cashflowx'),
      ),
    );
    return link.toString();
  }
}
