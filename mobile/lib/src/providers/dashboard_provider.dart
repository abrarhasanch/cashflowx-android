import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../dashboard/dashboard_metrics.dart';
import '../models/friend_loan.dart';
import '../models/transaction.dart';
import 'loan_providers.dart';
import 'transaction_providers.dart';

final dashboardProvider = Provider.autoDispose.family<DashboardMetrics, (String shelfId, String bookId)>((ref, key) {
  final transactionsValue = ref.watch(transactionsProvider(key));
  final loansValue = ref.watch(loansProvider(key));

  final transactions = transactionsValue.valueOrNull ?? const <BookTransaction>[];
  final loans = loansValue.valueOrNull ?? const <FriendLoan>[];
  double totalIn = 0;
  double totalOut = 0;
  final monthlyTotals = <String, double>{};
  final categoryTotals = <String, double>{};
  final topContacts = <String, double>{};
  final formatter = DateFormat('MMM yy');

  for (final txn in transactions) {
    final label = formatter.format(txn.createdAt);
    final signedAmount = txn.type == TransactionType.cashIn ? txn.amount : -txn.amount;
    monthlyTotals.update(label, (value) => value + signedAmount, ifAbsent: () => signedAmount);
    if (txn.type == TransactionType.cashIn) {
      totalIn += txn.amount;
    } else {
      totalOut += txn.amount;
    }
    if (txn.category != null) {
      categoryTotals.update(txn.category!, (value) => value + txn.amount, ifAbsent: () => txn.amount);
    }
    if (txn.contactId != null) {
      topContacts.update(txn.contactId!, (value) => value + txn.amount, ifAbsent: () => txn.amount);
    }
  }

  final loansMap = <String, double>{
    for (final loan in loans) loan.contactId: loan.net,
  };

  return DashboardMetrics(
    totalIn: totalIn,
    totalOut: totalOut,
    monthlyTotals: monthlyTotals,
    categoryTotals: categoryTotals,
    topContacts: topContacts,
    activeLoans: loansMap,
  );
});
