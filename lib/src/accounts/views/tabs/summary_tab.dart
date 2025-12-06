import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../providers/account_providers.dart';
import '../../../providers/transaction_providers.dart';
import '../../../providers/loan_providers.dart';
import '../../../models/transaction.dart';
import '../../../theme/app_theme.dart';

class SummaryTab extends ConsumerWidget {
  const SummaryTab({super.key, required this.accountId, required this.currencySymbol});

  final String accountId;
  final String currencySymbol;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountAsync = ref.watch(accountDetailProvider(accountId));
    final transactionsAsync = ref.watch(transactionsProvider(accountId));
    ref.watch(loansProvider(accountId));

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
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryTeal.withAlpha(89),
                    blurRadius: 24,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Balance',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '$currencySymbol${NumberFormat('#,##0.00').format(balance)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
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
        accountAsync.when(
          loading: () => const CircularProgressIndicator(),
          error: (e, _) => Text('Error: $e'),
          data: (account) {
            if (account == null) return const SizedBox();
            
            // Calculate based on account balance
            final balance = account.totalIn - account.totalOut;
            double iOwe = 0.0;
            double theyOwe = 0.0;
            
            if (balance > 0) {
              // Positive balance = I received more = I Owe
              iOwe = balance;
            } else if (balance < 0) {
              // Negative balance = I gave more = They Owe
              theyOwe = balance.abs();
            }

            return Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: AppTheme.glassGradient,
                color: AppTheme.surfaceDarkElevated.withAlpha(230),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppTheme.borderDark.withAlpha(153)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(46),
                    blurRadius: 18,
                    offset: const Offset(0, 12),
                  ),
                ],
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
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(width: 1, height: 48, color: AppTheme.borderDark.withAlpha(153)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('They Owe', style: TextStyle(color: AppTheme.textSecondary)),
                        const SizedBox(height: 8),
                        Text(
                          '$currencySymbol${NumberFormat('#,##0').format(theyOwe)}',
                          style: TextStyle(
                            color: AppTheme.primaryTeal,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
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

  final AccountTransaction transaction;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        gradient: AppTheme.glassGradient,
        color: AppTheme.surfaceDarkElevated.withAlpha(230),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.borderDark.withAlpha(153)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(31),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: transaction.type.toString().contains('cashIn')
                  ? AppTheme.primaryGradient
                  : const LinearGradient(
                      colors: [Color(0xFFEF4444), Color(0xFFFF7F7F)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              transaction.type.toString().contains('cashIn') ? Icons.arrow_downward : Icons.arrow_upward,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.remark ?? 'No remark',
                  style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w700),
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
              color: transaction.type.toString().contains('cashIn') ? AppTheme.primaryTeal : AppTheme.errorRed,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
