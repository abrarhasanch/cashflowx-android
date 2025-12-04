import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/transaction.dart';
import '../services/firestore_service.dart';
import '../transactions/services/transaction_exporter.dart';
import 'firestore_service_provider.dart';

class TransactionFilter {
  const TransactionFilter({
    this.type,
    this.memberUid,
    this.category,
    this.paymentMode,
    this.startDate,
    this.endDate,
  });

  final TransactionType? type;
  final String? memberUid;
  final String? category;
  final String? paymentMode;
  final DateTime? startDate;
  final DateTime? endDate;

  bool matches(BookTransaction transaction) {
    final matchType = type == null || transaction.type == type;
    final matchMember = memberUid == null || transaction.createdByUid == memberUid;
    final matchCategory = category == null || transaction.category == category;
    final matchPayment = paymentMode == null || transaction.paymentMode == paymentMode;
    final matchDate = (startDate == null || !transaction.createdAt.isBefore(startDate!)) &&
        (endDate == null || !transaction.createdAt.isAfter(endDate!));
    return matchType && matchMember && matchCategory && matchPayment && matchDate;
  }

  TransactionFilter copyWith({
    TransactionType? type,
    String? memberUid,
    String? category,
    String? paymentMode,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return TransactionFilter(
      type: type ?? this.type,
      memberUid: memberUid ?? this.memberUid,
      category: category ?? this.category,
      paymentMode: paymentMode ?? this.paymentMode,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  static const empty = TransactionFilter();
}

final transactionFilterProvider = StateProvider<TransactionFilter>((ref) => TransactionFilter.empty);

final transactionsProvider = StreamProvider.autoDispose.family<List<BookTransaction>, (String shelfId, String bookId)>((ref, key) {
  final (shelfId, bookId) = key;
  if (shelfId.isEmpty || bookId.isEmpty) {
    return Stream<List<BookTransaction>>.empty();
  }
  final filter = ref.watch(transactionFilterProvider);
  return ref.watch(firestoreServiceProvider).watchTransactions(shelfId: shelfId, bookId: bookId).map((txns) {
    return txns.where(filter.matches).toList();
  });
});

final transactionControllerProvider = StateNotifierProvider<TransactionController, AsyncValue<void>>((ref) {
  return TransactionController(ref.watch(firestoreServiceProvider));
});

final transactionExporterProvider = Provider<TransactionExporter>((ref) {
  return TransactionExporter();
});

class TransactionController extends StateNotifier<AsyncValue<void>> {
  TransactionController(this._service) : super(const AsyncData(null));

  final FirestoreService _service;

  Future<void> addTransaction(BookTransaction transaction) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _service.addTransaction(transaction));
  }

  Future<void> deleteTransaction(String shelfId, String bookId, String transactionId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _service.deleteTransaction(shelfId: shelfId, bookId: bookId, transactionId: transactionId));
  }
}
