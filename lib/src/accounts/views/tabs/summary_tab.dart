import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../providers/account_providers.dart';
import '../../../providers/transaction_providers.dart';
import '../../../providers/loan_providers.dart';
import '../../../theme/app_theme.dart';

class SummaryTab extends ConsumerWidget {
  const SummaryTab({super.key, required this.accountId, required this.currencySymbol});

  final String accountId;
  final String currencySymbol;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountAsync = ref.watch(accountDetailProvider(accountId));
    final transactionsAsync = ref.watch(transactionsProvider(accountId));
    final loansAsync = ref.watch(loansProvider(accountId));

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Account Balance Card
        accountAsync.when(
          loading: () => const CircularProgressIndicator(),
          error: (e, _) => Text('Error: $e'),
          data: (account) {
            if (account == null) return const SizedBox();
            final balance = account.totalIn - account.totalOut;
            
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Balance',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$currencySymbol${NumberFormat('#,##0.00').format(balance)}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _BalanceItem(
                          label: 'Cash In',
                          value: '$currencySymbol${NumberFormat('#,##0').format(account.totalIn)}',
                          icon: Icons.arrow_downward,
                        ),
                      ),
                      Expanded(
                        child: _BalanceItem(
                          label: 'Cash Out',
                          value: '$currencySymbol${NumberFormat('#,##0').format(account.totalOut)}',
                          icon: Icons.arrow_upward,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),

        const SizedBox(height: 24),

        // Loan Summary
        Text(
          'Loan Summary',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        loansAsync.when(
          loading: () => const CircularProgressIndicator(),
          error: (e, _) => Text('Error: $e'),
          data: (loans) {
            final iOwe = loans.where((l) => l.net < 0).fold<double>(0, (sum, l) => sum + l.net.abs());
            final theyOwe = loans.where((l) => l.net > 0).fold<double>(0, (sum, l) => sum + l.net);

            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.borderDark),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('I Owe', style: TextStyle(color: AppTheme.textSecondary)),
                        const SizedBox(height: 8),
                        Text(
                          '$currencySymbol${NumberFormat('#,##0').format(iOwe)}',
                          style: TextStyle(
                            color: AppTheme.errorRed,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(width: 1, height: 40, color: AppTheme.borderDark),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('They Owe', style: TextStyle(color: AppTheme.textSecondary)),
                        const SizedBox(height: 8),
                        Text(
                          '$currencySymbol${NumberFormat('#,##0').format(theyOwe)}',
                          style: TextStyle(
                            color: AppTheme.successGreen,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        const SizedBox(height: 24),

        // Recent Activity
        Text(
          'Recent Activity',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        transactionsAsync.when(
          loading: () => const CircularProgressIndicator(),
          error: (e, _) => Text('Error: $e'),
          data: (transactions) {
            final recent = transactions.take(5).toList();
            if (recent.isEmpty) {
              return Text('No transactions yet', style: TextStyle(color: AppTheme.textSecondary));
            }
            return Column(
              children: recent.map((txn) => _TransactionItem(
                transaction: txn,
                currencySymbol: currencySymbol,
              )).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _BalanceItem extends StatelessWidget {
  const _BalanceItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white70, size: 16),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _TransactionItem extends StatelessWidget {
  const _TransactionItem({
    required this.transaction,
    required this.currencySymbol,
  });

  final transaction;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderDark),
      ),
      child: Row(
        children: [
          Icon(
            transaction.type.toString().contains('cashIn') ? Icons.arrow_downward : Icons.arrow_upward,
            color: transaction.type.toString().contains('cashIn') ? AppTheme.successGreen : AppTheme.errorRed,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.remark ?? 'No remark',
                  style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w500),
                ),
                Text(
                  DateFormat('MMM d, yyyy').format(transaction.createdAt),
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            '$currencySymbol${NumberFormat('#,##0.00').format(transaction.amount)}',
            style: TextStyle(
              color: transaction.type.toString().contains('cashIn') ? AppTheme.successGreen : AppTheme.errorRed,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
