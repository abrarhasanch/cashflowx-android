// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../models/transaction.dart';
import '../../../providers/transaction_providers.dart';
import '../../../theme/app_theme.dart';

class CashEntriesTab extends ConsumerStatefulWidget {
  const CashEntriesTab({super.key, required this.accountId, required this.currencySymbol});

  final String accountId;
  final String currencySymbol;

  @override
  ConsumerState<CashEntriesTab> createState() => _CashEntriesTabState();
}

class _CashEntriesTabState extends ConsumerState<CashEntriesTab> {
  String _filter = 'all'; // all, pending, overdue, paid

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(transactionsProvider(widget.accountId));

    return Scaffold(
      body: transactionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (transactions) {
          final filteredTransactions = _filterTransactions(transactions);

          return Column(
            children: [
              // Filter chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'All',
                      selected: _filter == 'all',
                      onSelected: () => setState(() => _filter = 'all'),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Pending',
                      selected: _filter == 'pending',
                      onSelected: () => setState(() => _filter = 'pending'),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Overdue',
                      selected: _filter == 'overdue',
                      onSelected: () => setState(() => _filter = 'overdue'),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Paid',
                      selected: _filter == 'paid',
                      onSelected: () => setState(() => _filter = 'paid'),
                    ),
                  ],
                ),
              ),

              // Transaction list
              Expanded(
                child: filteredTransactions.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              size: 64,
                              color: AppTheme.textSecondary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No transactions yet',
                              style: TextStyle(
                                fontSize: 18,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap + to add a transaction',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredTransactions.length,
                        itemBuilder: (context, index) {
                          final transaction = filteredTransactions[index];
                          return _TransactionCard(
                            transaction: transaction,
                            accountId: widget.accountId,
                            currencySymbol: widget.currencySymbol,
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: AppTheme.backgroundDark,
                      builder: (context) => AddTransactionSheet(
                        accountId: widget.accountId,
                        currencySymbol: widget.currencySymbol,
                        initialType: TransactionType.cashIn,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryTeal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 8,
                    shadowColor: AppTheme.primaryTeal.withAlpha(89),
                  ),
                  icon: const Icon(Icons.arrow_downward),
                  label: const Text('Cash In', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: AppTheme.backgroundDark,
                      builder: (context) => AddTransactionSheet(
                        accountId: widget.accountId,
                        currencySymbol: widget.currencySymbol,
                        initialType: TransactionType.cashOut,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.errorRed,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 8,
                    shadowColor: AppTheme.errorRed.withAlpha(89),
                  ),
                  icon: const Icon(Icons.arrow_upward),
                  label: const Text('Cash Out', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<AccountTransaction> _filterTransactions(List<AccountTransaction> transactions) {
    final now = DateTime.now();
    
    switch (_filter) {
      case 'pending':
        return transactions.where((t) => 
          t.dueDate != null && !t.isPaid && t.dueDate!.isAfter(now)
        ).toList();
      case 'overdue':
        return transactions.where((t) => 
          t.dueDate != null && !t.isPaid && t.dueDate!.isBefore(now)
        ).toList();
      case 'paid':
        return transactions.where((t) => t.isPaid).toList();
      default:
        return transactions;
    }
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      backgroundColor: AppTheme.surfaceDarkElevated,
      selectedColor: AppTheme.primaryTeal.withAlpha(46),
      checkmarkColor: AppTheme.primaryTeal,
      labelStyle: TextStyle(
        color: selected ? AppTheme.primaryTeal : AppTheme.textSecondary,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: selected ? AppTheme.primaryTeal.withAlpha(178) : AppTheme.borderDark.withAlpha(153)),
      ),
    );
  }
}

class _TransactionCard extends ConsumerWidget {
  const _TransactionCard({
    required this.transaction,
    required this.accountId,
    required this.currencySymbol,
  });

  final AccountTransaction transaction;
  final String accountId;
  final String currencySymbol;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCashIn = transaction.type == TransactionType.cashIn;
    final isOverdue = transaction.dueDate != null && 
                     !transaction.isPaid && 
                     transaction.dueDate!.isBefore(DateTime.now());

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.transparent,
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _showTransactionSheet(context, ref, transaction),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: AppTheme.glassGradient,
            color: AppTheme.surfaceDarkElevated.withAlpha(235),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppTheme.borderDark.withAlpha(153)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(46),
                blurRadius: 16,
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
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: isCashIn ? AppTheme.primaryGradient : const LinearGradient(
                        colors: [Color(0xFFEF4444), Color(0xFFFF7F7F)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      isCashIn ? Icons.arrow_downward : Icons.arrow_upward,
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
                          isCashIn ? 'Cash In (I Took)' : 'Cash Out (They Took)',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (transaction.remark != null)
                          Text(
                            transaction.remark!,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Text(
                    '$currencySymbol${transaction.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: isCashIn ? AppTheme.primaryTeal : AppTheme.errorRed,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Date and status information
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Created: ${DateFormat('MMM dd, yyyy – HH:mm').format(transaction.createdAt)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  
                  if (transaction.dueDate != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.event,
                          size: 14,
                          color: isOverdue ? Colors.red : AppTheme.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Due: ${DateFormat('MMM dd, yyyy').format(transaction.dueDate!)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isOverdue ? Colors.red : AppTheme.textSecondary,
                            fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: transaction.isPaid
                                ? AppTheme.successGreen.withAlpha(46)
                                : isOverdue
                                    ? AppTheme.errorRed.withAlpha(46)
                                    : AppTheme.warningOrange.withAlpha(51),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            transaction.isPaid
                                ? 'Paid'
                                : isOverdue
                                    ? 'Overdue'
                                    : 'Pending',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: transaction.isPaid
                                  ? AppTheme.successGreen
                                  : isOverdue
                                      ? AppTheme.errorRed
                                      : AppTheme.warningOrange,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  
                  if (transaction.isPaid && transaction.paidAt != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          size: 14,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Paid on: ${DateFormat('MMM dd, yyyy').format(transaction.paidAt!)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              
              // Mark as paid button for unpaid transactions
              if (!transaction.isPaid)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final controller = ref.read(transactionControllerProvider.notifier);
                        await controller.markTransactionAsPaid(
                          accountId,
                          transaction.id,
                        );
                      },
                      icon: const Icon(Icons.check_circle_outline, size: 18),
                      label: const Text('Mark as Paid'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryTeal,
                        side: BorderSide(color: AppTheme.primaryTeal),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTransactionSheet(BuildContext context, WidgetRef ref, AccountTransaction transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.backgroundDark,
      builder: (context) => _TransactionDetailSheet(
        transaction: transaction,
        accountId: accountId,
        currencySymbol: currencySymbol,
      ),
    );
  }
}

class _TransactionDetailSheet extends ConsumerWidget {
  const _TransactionDetailSheet({
    required this.transaction,
    required this.accountId,
    required this.currencySymbol,
  });

  final AccountTransaction transaction;
  final String accountId;
  final String currencySymbol;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCashIn = transaction.type == TransactionType.cashIn;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: AppTheme.glassGradient,
          color: AppTheme.surfaceDarkElevated.withAlpha(242),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: AppTheme.borderDark.withAlpha(128)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(51),
              blurRadius: 20,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: isCashIn
                        ? AppTheme.primaryGradient
                        : const LinearGradient(
                            colors: [Color(0xFFEF4444), Color(0xFFFF7F7F)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    isCashIn ? Icons.arrow_downward : Icons.arrow_upward,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isCashIn ? 'Cash In' : 'Cash Out',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '$currencySymbol${transaction.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: isCashIn ? AppTheme.primaryTeal : AppTheme.errorRed,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: AppTheme.textSecondary),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            if (transaction.remark != null) ...[
              Text(
                'Remark',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDarkElevated.withAlpha(178),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.borderDark.withAlpha(102)),
                ),
                child: Text(
                  transaction.remark!,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            _DetailRow(
              icon: Icons.calendar_today,
              label: 'Created',
              value: DateFormat('MMM dd, yyyy HH:mm').format(transaction.createdAt),
            ),
            
            if (transaction.dueDate != null) ...[
              const SizedBox(height: 12),
              _DetailRow(
                icon: Icons.event,
                label: 'Due Date',
                value: DateFormat('MMM dd, yyyy').format(transaction.dueDate!),
              ),
            ],
            
            if (transaction.isPaid && transaction.paidAt != null) ...[
              const SizedBox(height: 12),
              _DetailRow(
                icon: Icons.check_circle,
                label: 'Paid On',
                value: DateFormat('MMM dd, yyyy HH:mm').format(transaction.paidAt!),
              ),
            ],
            
            if (transaction.category != null) ...[
              const SizedBox(height: 12),
              _DetailRow(
                icon: Icons.category,
                label: 'Category',
                value: transaction.category!,
              ),
            ],
            
            if (transaction.paymentMode != null) ...[
              const SizedBox(height: 12),
              _DetailRow(
                icon: Icons.payment,
                label: 'Payment Mode',
                value: transaction.paymentMode!,
              ),
            ],
            
            const SizedBox(height: 24),
            
            // Mark as Paid button for unpaid transactions
            if (!transaction.isPaid)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final controller = ref.read(transactionControllerProvider.notifier);
                      await controller.markTransactionAsPaid(accountId, transaction.id);
                      if (context.mounted) Navigator.pop(context);
                    },
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Mark as Paid'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryTeal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      shadowColor: AppTheme.primaryTeal.withAlpha(89),
                      elevation: 6,
                    ),
                  ),
                ),
              ),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _showEditSheet(context, ref);
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.textPrimary,
                      side: BorderSide(color: AppTheme.borderDark.withAlpha(153)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Transaction'),
                          content: const Text('Are you sure you want to delete this transaction?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: TextButton.styleFrom(foregroundColor: AppTheme.errorRed),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                      
                      if (confirmed == true && context.mounted) {
                        final controller = ref.read(transactionControllerProvider.notifier);
                        await controller.deleteTransaction(accountId, transaction.id);
                        if (context.mounted) Navigator.pop(context);
                      }
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.errorRed,
                      side: BorderSide(color: AppTheme.errorRed.withAlpha(204)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
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

  void _showEditSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.backgroundDark,
      builder: (context) => AddTransactionSheet(
        accountId: accountId,
        currencySymbol: currencySymbol,
        transaction: transaction,
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppTheme.textSecondary),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

// Add/Edit Transaction Sheet
class AddTransactionSheet extends ConsumerStatefulWidget {
  const AddTransactionSheet({
    super.key,
    required this.accountId,
    required this.currencySymbol,
    this.transaction,
    this.initialType,
  });

  final String accountId;
  final String currencySymbol;
  final AccountTransaction? transaction;
  final TransactionType? initialType;

  @override
  ConsumerState<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends ConsumerState<AddTransactionSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _remarkController = TextEditingController();
  final _categoryController = TextEditingController();
  final _paymentModeController = TextEditingController();
  
  TransactionType _type = TransactionType.cashIn;
  DateTime? _dueDate;
  late DateTime _createdAt;
  bool _hasDueDate = false;

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      _amountController.text = widget.transaction!.amount.toString();
      _remarkController.text = widget.transaction!.remark ?? '';
      _categoryController.text = widget.transaction!.category ?? '';
      _paymentModeController.text = widget.transaction!.paymentMode ?? '';
      _type = widget.transaction!.type;
      _dueDate = widget.transaction!.dueDate;
      _hasDueDate = _dueDate != null;
      _createdAt = widget.transaction!.createdAt;
    } else if (widget.initialType != null) {
      _type = widget.initialType!;
      _createdAt = DateTime.now();
    } else {
      _createdAt = DateTime.now();
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _remarkController.dispose();
    _categoryController.dispose();
    _paymentModeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.transaction != null;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: AppTheme.glassGradient,
            color: AppTheme.surfaceDarkElevated.withAlpha(242),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: AppTheme.borderDark.withAlpha(128)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(46),
                blurRadius: 20,
                offset: const Offset(0, -8),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing ? 'Edit Transaction' : 'Add Cash Entry',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Transaction Type
                const Text(
                  'Transaction Type',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _TypeButton(
                        label: 'Cash In\n(I Took)',
                        icon: Icons.arrow_downward,
                        color: AppTheme.primaryTeal,
                        gradient: AppTheme.primaryGradient,
                        selected: _type == TransactionType.cashIn,
                        onTap: () => setState(() => _type = TransactionType.cashIn),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _TypeButton(
                        label: 'Cash Out\n(They Took)',
                        icon: Icons.arrow_upward,
                        color: AppTheme.errorRed,
                        gradient: const LinearGradient(
                          colors: [Color(0xFFEF4444), Color(0xFFFF7F7F)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        selected: _type == TransactionType.cashOut,
                        onTap: () => setState(() => _type = TransactionType.cashOut),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Amount
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    prefixText: '${widget.currencySymbol} ',
                    filled: true,
                    fillColor: AppTheme.surfaceDarkElevated,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: AppTheme.borderDark.withAlpha(153)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: AppTheme.primaryTeal),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter valid amount';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Remark
                TextFormField(
                  controller: _remarkController,
                  decoration: InputDecoration(
                    labelText: 'Remark (Optional)',
                    filled: true,
                    fillColor: AppTheme.surfaceDarkElevated,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: AppTheme.borderDark.withAlpha(153)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: AppTheme.primaryTeal),
                    ),
                  ),
                  maxLines: 2,
                ),
                
                const SizedBox(height: 16),
                // Transaction date/time
                InkWell(
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _createdAt,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (!mounted) return;
                    if (pickedDate == null) return;

                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(_createdAt),
                    );

                    if (!mounted) return;

                    final time = pickedTime ?? TimeOfDay.fromDateTime(_createdAt);
                    setState(() {
                      _createdAt = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        time.hour,
                        time.minute,
                      );
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceDarkElevated,
                      border: Border.all(color: AppTheme.borderDark.withAlpha(153)),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.access_time, color: AppTheme.textSecondary),
                        const SizedBox(width: 12),
                        Text(
                          DateFormat('MMM dd, yyyy HH:mm').format(_createdAt),
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.edit_calendar, color: AppTheme.textSecondary),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Due Date Toggle
                SwitchListTile(
                  title: const Text('Set Due Date'),
                  value: _hasDueDate,
                  onChanged: (value) {
                    setState(() {
                      _hasDueDate = value;
                      if (!value) _dueDate = null;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                  activeThumbColor: AppTheme.primaryTeal,
                ),
                
                if (_hasDueDate) ...[
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _dueDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setState(() => _dueDate = picked);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceDarkElevated,
                        border: Border.all(color: AppTheme.borderDark.withAlpha(153)),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, color: AppTheme.textSecondary),
                          const SizedBox(width: 12),
                          Text(
                            _dueDate == null
                                ? 'Select due date'
                                : DateFormat('MMM dd, yyyy').format(_dueDate!),
                            style: TextStyle(
                              fontSize: 16,
                              color: _dueDate == null ? AppTheme.textSecondary : AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                
                const SizedBox(height: 16),
                
                // Category
                TextFormField(
                  controller: _categoryController,
                  decoration: InputDecoration(
                    labelText: 'Category (Optional)',
                    filled: true,
                    fillColor: AppTheme.surfaceDarkElevated,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: AppTheme.borderDark.withAlpha(153)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: AppTheme.primaryTeal),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Payment Mode
                TextFormField(
                  controller: _paymentModeController,
                  decoration: InputDecoration(
                    labelText: 'Payment Mode (Optional)',
                    filled: true,
                    fillColor: AppTheme.surfaceDarkElevated,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: AppTheme.borderDark.withAlpha(153)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: AppTheme.primaryTeal),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryTeal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 6,
                      shadowColor: AppTheme.primaryTeal.withAlpha(76),
                    ),
                    child: Text(isEditing ? 'Update Transaction' : 'Add Transaction'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_hasDueDate && _dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a due date')),
      );
      return;
    }

    final controller = ref.read(transactionControllerProvider.notifier);
    final amount = double.parse(_amountController.text);

    final transaction = AccountTransaction(
      id: widget.transaction?.id ?? '',
      accountId: widget.accountId,
      type: _type,
      amount: amount,
      createdByUid: widget.transaction?.createdByUid ?? '', // Preserve or set in controller
      remark: _remarkController.text.isEmpty ? null : _remarkController.text,
      category: _categoryController.text.isEmpty ? null : _categoryController.text,
      paymentMode: _paymentModeController.text.isEmpty ? null : _paymentModeController.text,
      dueDate: _dueDate,
      isPaid: widget.transaction?.isPaid ?? false,
      paidAt: widget.transaction?.paidAt,
      createdAt: _createdAt,
    );

    if (widget.transaction != null) {
      await controller.updateTransaction(transaction);
    } else {
      await controller.addTransaction(widget.accountId, transaction);
    }
    
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.transaction == null ? 'Transaction added' : 'Transaction updated'),
        ),
      );
    }
  }
}

class _TypeButton extends StatelessWidget {
  const _TypeButton({
    required this.label,
    required this.icon,
    required this.color,
    this.gradient,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final LinearGradient? gradient;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool showGradient = selected && gradient != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: showGradient ? gradient : null,
          color: showGradient ? null : (selected ? color.withAlpha(31) : AppTheme.surfaceDarkElevated),
          border: Border.all(
            color: selected ? color : AppTheme.borderDark.withAlpha(153),
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: color.withAlpha(64),
                    blurRadius: 14,
                    offset: const Offset(0, 10),
                  ),
                ]
              : [],
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: selected ? Colors.white : AppTheme.textSecondary,
              size: 22,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? Colors.white : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
