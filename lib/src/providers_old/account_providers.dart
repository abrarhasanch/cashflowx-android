import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/account.dart';
import '../services/firestore_service.dart';
import 'firestore_service_provider.dart';
import 'firebase_providers.dart';

/// Stream all accounts for the current user
final accountsProvider = StreamProvider<List<Account>>((ref) {
  final user = ref.watch(authStateChangesProvider).valueOrNull;
  if (user == null) return const Stream.empty();
  
  final service = ref.watch(firestoreServiceProvider);
  return service.watchAccountsForUser(user.uid);
});

/// Get a specific account by ID
final accountDetailProvider = StreamProvider.family<Account?, String>((ref, accountId) {
  if (accountId.isEmpty) return const Stream.empty();
  
  final service = ref.watch(firestoreServiceProvider);
  return service.watchAccount(accountId);
});

/// Controller for account CRUD operations
final accountControllerProvider = StateNotifierProvider<AccountController, AsyncValue<Account?>>((ref) {
  return AccountController(ref.watch(firestoreServiceProvider), ref.watch(firebaseAuthProvider));
});

class AccountController extends StateNotifier<AsyncValue<Account?>> {
  AccountController(this._service, this._auth) : super(const AsyncData(null));

  final FirestoreService _service;
  final _auth;

  Future<Account?> createAccount(String title, String description, String currency) async {
    state = const AsyncLoading();
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      final account = Account(
        id: '',
        title: title,
        description: description,
        currency: currency,
        ownerUid: user.uid,
        createdAt: DateTime.now(),
        members: [AccountMember(uid: user.uid, role: MemberRole.owner)],
        memberUids: [user.uid],
      );

      final createdAccount = await _service.createAccount(account);
      state = AsyncData(createdAccount);
      return createdAccount;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return null;
    }
  }

  Future<bool> updateAccount(Account account) async {
    state = const AsyncLoading();
    try {
      await _service.updateAccount(account);
      state = AsyncData(account);
      return true;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return false;
    }
  }

  Future<bool> deleteAccount(String accountId) async {
    state = const AsyncLoading();
    try {
      await _service.deleteAccount(accountId);
      state = const AsyncData(null);
      return true;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return false;
    }
  }

  Future<bool> addMember(String accountId, String memberUid, MemberRole role) async {
    try {
      final account = await _service.watchAccount(accountId).first;
      if (account == null) throw Exception('Account not found');

      final updatedMembers = [...account.members, AccountMember(uid: memberUid, role: role)];
      final updatedMemberUids = [...account.memberUids, memberUid];

      await _service.updateAccount(account.copyWith(
        members: updatedMembers,
        memberUids: updatedMemberUids,
      ));
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeMember(String accountId, String memberUid) async {
    try {
      final account = await _service.watchAccount(accountId).first;
      if (account == null) throw Exception('Account not found');

      final updatedMembers = account.members.where((m) => m.uid != memberUid).toList();
      final updatedMemberUids = account.memberUids.where((uid) => uid != memberUid).toList();

      await _service.updateAccount(account.copyWith(
        members: updatedMembers,
        memberUids: updatedMemberUids,
      ));
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateMemberRole(String accountId, String memberUid, MemberRole newRole) async {
    try {
      final account = await _service.watchAccount(accountId).first;
      if (account == null) throw Exception('Account not found');

      final updatedMembers = account.members.map((m) {
        if (m.uid == memberUid) {
          return m.copyWith(role: newRole);
        }
        return m;
      }).toList();

      await _service.updateAccount(account.copyWith(members: updatedMembers));
      return true;
    } catch (e) {
      return false;
    }
  }
}
