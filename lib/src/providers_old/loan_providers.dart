import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/friend_loan.dart';
import '../models/loan_event.dart';
import '../services/firestore_service.dart';
import 'firestore_service_provider.dart';

final loansProvider = StreamProvider.autoDispose.family<List<FriendLoan>, (String shelfId, String bookId)>((ref, key) {
  final (shelfId, bookId) = key;
  if (shelfId.isEmpty || bookId.isEmpty) {
    return Stream<List<FriendLoan>>.empty();
  }
  return ref.watch(firestoreServiceProvider).watchLoans(shelfId: shelfId, bookId: bookId);
});

final loanEventsProvider = StreamProvider.autoDispose.family<List<LoanEvent>, (String shelfId, String bookId, String loanId)>((ref, key) {
  final (shelfId, bookId, loanId) = key;
  if (shelfId.isEmpty || bookId.isEmpty || loanId.isEmpty) {
    return Stream<List<LoanEvent>>.empty();
  }
  return ref.watch(firestoreServiceProvider).watchLoanEvents(shelfId: shelfId, bookId: bookId, loanId: loanId);
});

final loanControllerProvider = StateNotifierProvider<LoanController, AsyncValue<void>>((ref) {
  return LoanController(ref.watch(firestoreServiceProvider));
});

class LoanController extends StateNotifier<AsyncValue<void>> {
  LoanController(this._service) : super(const AsyncData(null));

  final FirestoreService _service;

  Future<void> addLoanEvent({
    required String shelfId,
    required String bookId,
    required String loanId,
    required LoanEvent event,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _service.addLoanEvent(
          shelfId: shelfId,
          bookId: bookId,
          loanId: loanId,
          event: event,
        ));
  }

  Future<void> settleLoan({required String shelfId, required String bookId, required String loanId}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _service.settleLoan(shelfId: shelfId, bookId: bookId, loanId: loanId));
  }

  Future<void> createLoan({required FriendLoan loan}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _service.createLoan(loan));
  }
}
