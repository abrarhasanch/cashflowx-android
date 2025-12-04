import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../auth/controllers/auth_controller.dart';
import '../../models/transaction.dart';
import '../../theme/app_theme.dart';
import '../../widgets/empty_state.dart';
import '../../providers/book_providers.dart';
import '../../providers/transaction_providers.dart';

class TransactionsTab extends ConsumerStatefulWidget {
  const TransactionsTab({super.key, required this.shelfId, required this.bookId});

  final String shelfId;
  final String bookId;

  @override
  ConsumerState<TransactionsTab> createState() => _TransactionsTabState();
}

class _TransactionsTabState extends ConsumerState<TransactionsTab> {
  String _query = '';
  bool _exporting = false;
  String _durationFilter = 'All Time';
  String _typeFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionsProvider((widget.shelfId, widget.bookId)));
    final bookAsync = ref.watch(bookDetailProvider((widget.shelfId, widget.bookId)));
    final book = bookAsync.valueOrNull;
    final currency = book?.currency ?? 'BDT';
    final currencySymbol = AppTheme.getCurrencySymbol(currency);

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      body: transactions.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error', style: const TextStyle(color: AppTheme.errorRed))),
        data: (data) {
          // Apply filters
          var filtered = data.where((txn) {
            if (_query.isNotEmpty && !(txn.remark?.toLowerCase().contains(_query.toLowerCase()) ?? false)) {
              return false;
            }
            if (_typeFilter == 'Cash In' && txn.type != TransactionType.cashIn) return false;
            if (_typeFilter == 'Cash Out' && txn.type != TransactionType.cashOut) return false;
            return true;
          }).toList();

          // Calculate totals
          final totalIn = data.where((t) => t.type == TransactionType.cashIn).fold<double>(0, (sum, t) => sum + t.amount);
          final totalOut = data.where((t) => t.type == TransactionType.cashOut).fold<double>(0, (sum, t) => sum + t.amount);
          final netBalance = totalIn - totalOut;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search and Filters Row
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceDark,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.borderColor),
                        ),
                        child: TextField(
                          style: const TextStyle(color: AppTheme.textPrimary),
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.search, color: AppTheme.textSecondary),
                            hintText: 'Search by remark or amount...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                          onChanged: (value) => setState(() => _query = value),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    _FilterDropdown(
                      value: _durationFilter,
                      items: const ['All Time', 'Today', 'This Week', 'This Month'],
                      onChanged: (v) => setState(() => _durationFilter = v ?? 'All Time'),
                    ),
                    const SizedBox(width: 8),
                    _FilterDropdown(
                      value: _typeFilter,
                      items: const ['All', 'Cash In', 'Cash Out'],
                      onChanged: (v) => setState(() => _typeFilter = v ?? 'All'),
                      label: 'Types',
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Action Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _ActionButton(
                      icon: Icons.add,
                      label: 'Cash In',
                      color: AppTheme.successGreen,
                      onTap: () => _showTransactionSheet(context, TransactionType.cashIn),
                    ),
                    const SizedBox(width: 8),
                    _ActionButton(
                      icon: Icons.add,
                      label: 'Cash Out',
                      color: AppTheme.errorRed,
                      onTap: () => _showTransactionSheet(context, TransactionType.cashOut),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Summary Stats Cards
                Row(
                  children: [
                    Expanded(
                      child: _SummaryStatCard(
                        title: 'Total Cash In',
                        value: '$currencySymbol ${_formatNumber(totalIn)}',
                        subtitle: 'Last 7 days: $currencySymbol ${_formatNumber(totalIn)}',
                        icon: Icons.trending_up,
                        color: AppTheme.successGreen,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SummaryStatCard(
                        title: 'Total Cash Out',
                        value: '$currencySymbol ${_formatNumber(totalOut)}',
                        subtitle: 'Last 7 days: $currencySymbol ${_formatNumber(totalOut)}',
                        icon: Icons.trending_down,
                        color: AppTheme.errorRed,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _SummaryStatCard(
                        title: 'Net Cash Flow',
                        value: '$currencySymbol ${_formatNumber(netBalance)}',
                        subtitle: 'Avg daily: $currencySymbol ${_formatNumber(netBalance / 30)}',
                        icon: Icons.account_balance_wallet,
                        color: AppTheme.accentPurple,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SummaryStatCard(
                        title: 'Transactions',
                        value: data.length.toString(),
                        subtitle: 'Last 30 days: ${data.length}',
                        icon: Icons.receipt_long,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Summary Bars
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: AppTheme.cashInCard,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Cash In', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.successGreen)),
                            const SizedBox(height: 8),
                            Text(
                              '$currencySymbol ${_formatNumber(totalIn)}',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: AppTheme.successGreen,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: AppTheme.cashOutCard,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Cash Out', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.errorRed)),
                            const SizedBox(height: 8),
                            Text(
                              '$currencySymbol ${_formatNumber(totalOut)}',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: AppTheme.errorRed,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: AppTheme.netBalanceCard,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Net Balance', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.accentPurple)),
                            const SizedBox(height: 8),
                            Text(
                              '$currencySymbol ${_formatNumber(netBalance)}',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: AppTheme.accentPurple,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Transactions Table
                Container(
                  decoration: AppTheme.cardDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Showing ${filtered.length} of ${data.length} entries',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
                            ),
                            Row(
                              children: [
                                _SmallButton(
                                  icon: Icons.picture_as_pdf,
                                  label: 'PDF',
                                  onTap: () => _exportTransactions(filtered),
                                  loading: _exporting,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: AppTheme.borderColor),
                      
                      // Table Header
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        color: AppTheme.surfaceDarkElevated.withOpacity(0.3),
                        child: Row(
                          children: [
                            _TableHeader('DATE & TIME', flex: 2),
                            _TableHeader('DETAILS', flex: 3),
                            _TableHeader('BILL', flex: 2),
                            _TableHeader('AMOUNT', flex: 2, align: TextAlign.right),
                            _TableHeader('BALANCE', flex: 2, align: TextAlign.right),
                          ],
                        ),
                      ),
                      
                      // Transaction Rows
                      if (filtered.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(40),
                          child: EmptyState(
                            icon: Icons.receipt_long_outlined,
                            message: 'No transactions found',
                            subtitle: 'Add your first transaction to get started',
                          ),
                        )
                      else
                        ...filtered.asMap().entries.map((entry) {
                          final index = entry.key;
                          final txn = entry.value;
                          // Calculate running balance
                          final runningBalance = filtered
                              .take(index + 1)
                              .fold<double>(0, (sum, t) => sum + (t.type == TransactionType.cashIn ? t.amount : -t.amount));
                          return _TransactionRow(
                            transaction: txn,
                            currencySymbol: currencySymbol,
                            runningBalance: runningBalance,
                          );
                        }),
                      
                      const SizedBox(height: 20),
                    ],
                  ),
                ),

                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatNumber(double value) {
    return value.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  void _showTransactionSheet(BuildContext context, TransactionType defaultType) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddTransactionSheet(
        shelfId: widget.shelfId,
        bookId: widget.bookId,
        defaultType: defaultType,
      ),
    );
  }

  Future<void> _exportTransactions(List<BookTransaction> transactions) async {
    if (_exporting || transactions.isEmpty) {
      if (transactions.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nothing to export.')));
      }
      return;
    }

    final bookAsync = ref.read(bookDetailProvider((widget.shelfId, widget.bookId)));
    final book = bookAsync.valueOrNull;
    if (book == null) return;

    final exporter = ref.read(transactionExporterProvider);
    setState(() => _exporting = true);
    try {
      final file = await exporter.export(book: book, transactions: transactions);
      if (!mounted) return;
      await Share.shareXFiles([XFile(file.path)], text: 'Transactions export for ${book.title}');
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Export failed: $error')));
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }
}

class _FilterDropdown extends StatelessWidget {
  const _FilterDropdown({required this.value, required this.items, required this.onChanged, this.label});
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          dropdownColor: AppTheme.surfaceDark,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.textPrimary),
          icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.textSecondary, size: 18),
          items: items.map((item) => DropdownMenuItem(value: item, child: Text(label != null && item == items.first ? '$label: $item' : item))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, required this.label, required this.color, required this.onTap});
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}

class _SummaryStatCard extends StatelessWidget {
  const _SummaryStatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color)),
              Icon(icon, color: color, size: 18),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.textPrimary, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color.withOpacity(0.8), fontSize: 10)),
        ],
      ),
    );
  }
}

class _SmallButton extends StatelessWidget {
  const _SmallButton({required this.icon, required this.label, required this.onTap, this.loading = false});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: loading ? null : onTap,
      icon: loading
          ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
          : Icon(icon, size: 14),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppTheme.textSecondary,
        side: const BorderSide(color: AppTheme.borderColor),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        textStyle: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader(this.text, {this.flex = 1, this.align = TextAlign.left});
  final String text;
  final int flex;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: align,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
      ),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({required this.transaction, required this.currencySymbol, required this.runningBalance});
  final BookTransaction transaction;
  final String currencySymbol;
  final double runningBalance;

  @override
  Widget build(BuildContext context) {
    final isCashIn = transaction.type == TransactionType.cashIn;
    final dateFormat = DateFormat('MMM dd, yyyy');
    final timeFormat = DateFormat('hh:mm a');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.borderColor, width: 0.5)),
      ),
      child: Row(
        children: [
          // Date & Time
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateFormat.format(transaction.createdAt),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.textPrimary),
                ),
                Text(
                  timeFormat.format(transaction.createdAt),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary, fontSize: 11),
                ),
              ],
            ),
          ),
          // Details
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.remark ?? '—',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (transaction.category != null)
                  Text(
                    transaction.category!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary, fontSize: 11),
                  ),
              ],
            ),
          ),
          // Bill
          Expanded(
            flex: 2,
            child: Text(
              '—',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
            ),
          ),
          // Amount
          Expanded(
            flex: 2,
            child: Text(
              '$currencySymbol ${transaction.amount.toStringAsFixed(2)}',
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isCashIn ? AppTheme.successGreen : AppTheme.errorRed,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          // Balance
          Expanded(
            flex: 2,
            child: Text(
              '$currencySymbol ${runningBalance.toStringAsFixed(2)}',
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

class AddTransactionSheet extends ConsumerStatefulWidget {
  const AddTransactionSheet({super.key, required this.shelfId, required this.bookId, this.defaultType = TransactionType.cashIn});

  final String shelfId;
  final String bookId;
  final TransactionType defaultType;

  @override
  ConsumerState<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends ConsumerState<AddTransactionSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _remarkController = TextEditingController();
  final _categoryController = TextEditingController();
  final _paymentModeController = TextEditingController();
  late TransactionType type;

  @override
  void initState() {
    super.initState();
    type = widget.defaultType;
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
    final auth = ref.watch(authStateChangesProvider).valueOrNull;
    final controller = ref.watch(transactionControllerProvider);
    final isCashIn = type == TransactionType.cashIn;

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 24,
        right: 24,
        top: 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.borderColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isCashIn ? AppTheme.successGreen.withOpacity(0.1) : AppTheme.errorRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isCashIn ? Icons.arrow_downward : Icons.arrow_upward,
                    color: isCashIn ? AppTheme.successGreen : AppTheme.errorRed,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isCashIn ? 'Money In' : 'Money Out',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      isCashIn ? 'Record a receipt' : 'Record a payment',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Type toggle
            Row(
              children: [
                Expanded(
                  child: _TypeToggle(
                    label: 'Cash In',
                    isSelected: type == TransactionType.cashIn,
                    color: AppTheme.successGreen,
                    onTap: () => setState(() => type = TransactionType.cashIn),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _TypeToggle(
                    label: 'Cash Out',
                    isSelected: type == TransactionType.cashOut,
                    color: AppTheme.errorRed,
                    onTap: () => setState(() => type = TransactionType.cashOut),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Amount
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(color: AppTheme.textPrimary, fontSize: 24, fontWeight: FontWeight.w600),
              decoration: const InputDecoration(
                labelText: 'Amount *',
                prefixIcon: Icon(Icons.attach_money),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Amount is required';
                if (double.tryParse(value) == null) return 'Enter a valid number';
                if (double.parse(value) <= 0) return 'Amount must be positive';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Remark
            TextFormField(
              controller: _remarkController,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: const InputDecoration(
                labelText: 'Remark / Description',
                prefixIcon: Icon(Icons.notes),
              ),
            ),
            const SizedBox(height: 16),

            // Category & Payment Mode
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _categoryController,
                    style: const TextStyle(color: AppTheme.textPrimary),
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      prefixIcon: Icon(Icons.category_outlined),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _paymentModeController,
                    style: const TextStyle(color: AppTheme.textPrimary),
                    decoration: const InputDecoration(
                      labelText: 'Payment Mode',
                      prefixIcon: Icon(Icons.payment),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.isLoading
                    ? null
                    : () {
                        if (_formKey.currentState?.validate() ?? false) {
                          final txn = BookTransaction(
                            id: '',
                            shelfId: widget.shelfId,
                            bookId: widget.bookId,
                            amount: double.parse(_amountController.text.trim()),
                            type: type,
                            createdAt: DateTime.now(),
                            createdByUid: auth?.uid ?? '',
                            remark: _remarkController.text.trim().isEmpty ? null : _remarkController.text.trim(),
                            category: _categoryController.text.trim().isEmpty ? null : _categoryController.text.trim(),
                            paymentMode: _paymentModeController.text.trim().isEmpty ? null : _paymentModeController.text.trim(),
                          );
                          ref.read(transactionControllerProvider.notifier).addTransaction(txn);
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${isCashIn ? 'Cash In' : 'Cash Out'} recorded!'),
                              backgroundColor: isCashIn ? AppTheme.successGreen : AppTheme.errorRed,
                            ),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCashIn ? AppTheme.successGreen : AppTheme.errorRed,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: controller.isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text('Save ${isCashIn ? 'Cash In' : 'Cash Out'}'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeToggle extends StatelessWidget {
  const _TypeToggle({required this.label, required this.isSelected, required this.color, required this.onTap});
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected ? color : AppTheme.borderColor),
        ),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: isSelected ? color : AppTheme.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ),
    );
  }
}
