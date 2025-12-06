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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedFilter = 'upcoming'; // upcoming, overdue, all

  @override
  Widget build(BuildContext context) {
    final accountsAsync = ref.watch(accountsProvider);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: const AppDrawer(),
      body: SafeArea(
        child: accountsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text(
              'Error: $error',
              style: const TextStyle(color: Colors.red),
            ),
          ),
          data: (accounts) {
            if (accounts.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _HeaderCard(onMenuTap: () => _scaffoldKey.currentState?.openDrawer()),
                    const SizedBox(height: 24),
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 72,
                      color: AppTheme.textSecondary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No accounts yet',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Create an account to start tracking due dates.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  child: Builder(
                    builder: (context) => _HeaderCard(
                      onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _FilterBar(
                    selectedFilter: _selectedFilter,
                    onSelected: (value) => setState(() => _selectedFilter = value),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
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

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppTheme.glassGradient,
              color: Theme.of(context).cardColor.withAlpha(230),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.borderDark.withAlpha(140)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(40),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        accountName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen.withAlpha(38),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.primaryGreen.withAlpha(89)),
                      ),
                      child: Text(
                        '${filteredTransactions.length}',
                        style: const TextStyle(
                          color: AppTheme.primaryGreen,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...filteredTransactions.map((transaction) {
                  return _buildTransactionCard(accountId, transaction);
                }),
              ],
            ),
          ),
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

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppTheme.glassGradient,
        color: Theme.of(context).cardColor.withAlpha(220),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.borderDark.withAlpha(130)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(36),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
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
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      transaction.category ?? 'General',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              Text(
                '৳${transaction.amount.toStringAsFixed(2)}',
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
                isOverdue ? Icons.warning_rounded : Icons.schedule_rounded,
                size: 16,
                color: dueDateColor,
              ),
              const SizedBox(width: 6),
              Text(
                dueDateLabel,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: dueDateColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(width: 10),
              Text(
                DateFormat('MMM dd, yyyy').format(dueDate),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
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
                    vertical: 8,
                  ),
                  backgroundColor: AppTheme.primaryGreen.withAlpha(38),
                  foregroundColor: AppTheme.primaryGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  'Mark as Paid',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.onMenuTap});

  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGreen.withAlpha(80),
            blurRadius: 26,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CircleIconButton(icon: Icons.menu, onTap: onMenuTap),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Due Date Manager',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Track upcoming and overdue payments across accounts',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withAlpha(220),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.selectedFilter, required this.onSelected});

  final String selectedFilter;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        gradient: AppTheme.glassGradient,
        color: Theme.of(context).cardColor.withAlpha(220),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.borderDark.withAlpha(130)),
      ),
      child: Row(
        children: [
          _FilterChip(
            label: 'Upcoming',
            selected: selectedFilter == 'upcoming',
            onTap: () => onSelected('upcoming'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Overdue',
            selected: selectedFilter == 'overdue',
            onTap: () => onSelected('overdue'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'All',
            selected: selectedFilter == 'all',
            onTap: () => onSelected('all'),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      labelStyle: TextStyle(
        color: selected ? AppTheme.primaryGreen : AppTheme.textSecondary,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: Theme.of(context).cardColor.withAlpha(180),
      selectedColor: AppTheme.primaryGreen.withAlpha(38),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      side: BorderSide(color: selected ? AppTheme.primaryGreen.withAlpha(120) : AppTheme.borderDark),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(28),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
