import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../models/transaction.dart';
import '../../providers/account_providers.dart';
import '../../providers/transaction_providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_drawer.dart';

class DueDateManagerScreen extends ConsumerStatefulWidget {
  const DueDateManagerScreen({super.key});

  @override
  ConsumerState<DueDateManagerScreen> createState() => _DueDateManagerScreenState();
}

class _DueDateManagerScreenState extends ConsumerState<DueDateManagerScreen> {
  String _selectedFilter = 'upcoming'; // upcoming, overdue, all

  @override
  Widget build(BuildContext context) {
    final accountsAsync = ref.watch(accountsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Due Date Manager'),
        elevation: 0,
      ),
      body: accountsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            'Error: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
        data: (accounts) {
          if (accounts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 64,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No accounts yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Filter chips
              Container(
                padding: const EdgeInsets.all(16),
                color: AppTheme.cardDark,
                child: Row(
                  children: [
                    _buildFilterChip('Upcoming', 'upcoming'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Overdue', 'overdue'),
                    const SizedBox(width: 8),
                    _buildFilterChip('All', 'all'),
                  ],
                ),
              ),
              
              // List of transactions with due dates
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: accounts.length,
                  itemBuilder: (context, index) {
                    final account = accounts[index];
                    return _buildAccountSection(account.id, account.title);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedFilter = value;
          });
        }
      },
      backgroundColor: AppTheme.backgroundDark,
      selectedColor: AppTheme.primaryGreen.withOpacity(0.2),
      checkmarkColor: AppTheme.primaryGreen,
      labelStyle: TextStyle(
        color: isSelected ? AppTheme.primaryGreen : Colors.grey[400],
      ),
    );
  }

  Widget _buildAccountSection(String accountId, String accountName) {
    final transactionsAsync = ref.watch(transactionsProvider(accountId));

    return transactionsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => const SizedBox.shrink(),
      data: (transactions) {
        // Filter transactions with due dates
        final filteredTransactions = transactions.where((t) {
          if (t.dueDate == null) return false;

          final now = DateTime.now();
          final dueDate = t.dueDate!;
          final isOverdue = dueDate.isBefore(now) && !t.isPaid;
          final isUpcoming = dueDate.isAfter(now) && !t.isPaid;

          if (_selectedFilter == 'overdue') return isOverdue;
          if (_selectedFilter == 'upcoming') return isUpcoming;
          if (_selectedFilter == 'all') return !t.isPaid;

          return false;
        }).toList();

        // Sort by due date
        filteredTransactions.sort((a, b) => a.dueDate!.compareTo(b.dueDate!));

        if (filteredTransactions.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    color: AppTheme.primaryGreen,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      accountName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${filteredTransactions.length}',
                      style: const TextStyle(
                        color: AppTheme.primaryGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ...filteredTransactions.map((transaction) {
              return _buildTransactionCard(accountId, transaction);
            }),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildTransactionCard(String accountId, AccountTransaction transaction) {
    final now = DateTime.now();
    final dueDate = transaction.dueDate!;
    final isOverdue = dueDate.isBefore(now);
    final daysUntilDue = dueDate.difference(now).inDays;

    String dueDateLabel;
    Color dueDateColor;

    if (isOverdue) {
      final daysOverdue = now.difference(dueDate).inDays;
      dueDateLabel = daysOverdue == 0
          ? 'Due today'
          : 'Overdue by $daysOverdue ${daysOverdue == 1 ? 'day' : 'days'}';
      dueDateColor = Colors.red;
    } else {
      dueDateLabel = daysUntilDue == 0
          ? 'Due today'
          : 'Due in $daysUntilDue ${daysUntilDue == 1 ? 'day' : 'days'}';
      dueDateColor = daysUntilDue <= 3 ? Colors.orange : AppTheme.primaryGreen;
    }

    return Card(
      color: AppTheme.cardDark,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.remark ?? 'No description',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        transaction.category ?? 'General',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '₹${transaction.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: transaction.type == TransactionType.cashIn
                        ? AppTheme.primaryGreen
                        : Colors.red[400],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  isOverdue ? Icons.warning : Icons.schedule,
                  size: 16,
                  color: dueDateColor,
                ),
                const SizedBox(width: 4),
                Text(
                  dueDateLabel,
                  style: TextStyle(
                    fontSize: 14,
                    color: dueDateColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormat('MMM dd, yyyy').format(dueDate),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () async {
                    await ref
                        .read(transactionControllerProvider.notifier)
                        .markTransactionAsPaid(accountId, transaction.id);
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    backgroundColor: AppTheme.primaryGreen.withOpacity(0.2),
                  ),
                  child: const Text(
                    'Mark as Paid',
                    style: TextStyle(
                      color: AppTheme.primaryGreen,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
