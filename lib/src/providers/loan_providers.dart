import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/friend_loan.dart';
import '../models/loan_event.dart';
import '../services/firestore_service.dart';
import 'firestore_service_provider.dart';
import 'firebase_providers.dart';

/// Stream all loans for a specific account
final loansProvider = StreamProvider.family<List<FriendLoan>, String>((ref, accountId) {
  if (accountId.isEmpty) return const Stream.empty();
  final service = ref.watch(firestoreServiceProvider);
  return service.watchLoans(accountId);
});

/// Stream loan events for a specific loan
final loanEventsProvider = StreamProvider.family<List<LoanEvent>, ({String accountId, String loanId})>((ref, params) {
  if (params.accountId.isEmpty || params.loanId.isEmpty) return const Stream.empty();
  final service = ref.watch(firestoreServiceProvider);
  return service.watchLoanEvents(params.accountId, params.loanId);
});

/// Controller for loan operations
final loanControllerProvider = StateNotifierProvider<LoanController, AsyncValue<void>>((ref) {
  return LoanController(ref.watch(firestoreServiceProvider), ref.watch(firebaseAuthProvider));
});

class LoanController extends StateNotifier<AsyncValue<void>> {
  LoanController(this._service, this._auth) : super(const AsyncData(null));

  final FirestoreService _service;
  final _auth;

  Future<FriendLoan?> createLoan(String accountId, String contactId) async {
    state = const AsyncLoading();
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No user logged in');

      final loan = FriendLoan(
        id: '',
        accountId: accountId,
        contactId: contactId,
        createdByUid: user.uid,
      );

      final created = await _service.createLoan(loan);
      state = const AsyncData(null);
      return created;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return null;
    }
  }

  Future<void> addLoanEvent({
    required String accountId,
    required String loanId,
    required LoanEventType type,
    required double amount,
    String? note,
  }) async {
    state = const AsyncLoading();
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No user logged in');

      final event = LoanEvent(
        id: '',
        loanId: loanId,
        accountId: accountId,
        type: type,
        amount: amount,
        createdAt: DateTime.now(),
        createdByUid: user.uid,
        note: note,
      );

      await _service.addLoanEvent(accountId, loanId, event);
      state = const AsyncData(null);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  Future<void> settleLoan(String accountId, String loanId) async {
    state = const AsyncLoading();
    try {
      await _service.settleLoan(accountId, loanId);
      state = const AsyncData(null);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }
}
