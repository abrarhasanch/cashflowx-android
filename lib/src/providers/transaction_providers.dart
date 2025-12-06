import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/transaction.dart';
import '../services/firestore_service.dart';
import 'firestore_service_provider.dart';
import 'firebase_providers.dart';

/// Stream all transactions for a specific account
final transactionsProvider = StreamProvider.family<List<AccountTransaction>, String>((ref, accountId) {
  if (accountId.isEmpty) return const Stream.empty();
  final service = ref.watch(firestoreServiceProvider);
  return service.watchTransactions(accountId);
});

/// Stream pending transactions (with due dates, not paid)
final pendingTransactionsProvider = StreamProvider.family<List<AccountTransaction>, String>((ref, accountId) {
  if (accountId.isEmpty) return const Stream.empty();
  final service = ref.watch(firestoreServiceProvider);
  return service.watchPendingTransactions(accountId);
});

/// Stream overdue transactions
final overdueTransactionsProvider = StreamProvider.family<List<AccountTransaction>, String>((ref, accountId) {
  if (accountId.isEmpty) return const Stream.empty();
  final service = ref.watch(firestoreServiceProvider);
  return service.watchOverdueTransactions(accountId);
});

/// Controller for transaction operations
final transactionControllerProvider = StateNotifierProvider<TransactionController, AsyncValue<void>>((ref) {
  return TransactionController(ref.watch(firestoreServiceProvider), ref.watch(firebaseAuthProvider));
});

class TransactionController extends StateNotifier<AsyncValue<void>> {
  TransactionController(this._service, this._auth) : super(const AsyncData(null));

  final FirestoreService _service;
  final FirebaseAuth _auth;

  Future<void> addTransaction(String accountId, AccountTransaction transaction) async {
    state = const AsyncLoading();
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No user logged in');

      final newTransaction = transaction.copyWith(
        id: '',
        createdByUid: user.uid,
      );

      await _service.addTransaction(newTransaction);
      state = const AsyncData(null);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  Future<void> updateTransaction(AccountTransaction transaction) async {
    state = const AsyncLoading();
    try {
      await _service.updateTransaction(transaction);
      state = const AsyncData(null);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  Future<void> markTransactionAsPaid(String accountId, String transactionId) async {
    state = const AsyncLoading();
    try {
      await _service.markTransactionAsPaid(accountId, transactionId);
      state = const AsyncData(null);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  Future<void> deleteTransaction(String accountId, String transactionId) async {
    state = const AsyncLoading();
    try {
      await _service.deleteTransaction(accountId, transactionId);
      state = const AsyncData(null);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }
}
