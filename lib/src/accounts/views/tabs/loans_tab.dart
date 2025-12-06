import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../models/contact.dart';
import '../../../models/friend_loan.dart';
import '../../../models/loan_event.dart';
import '../../../providers/contact_providers.dart';
import '../../../providers/loan_providers.dart';
import '../../../theme/app_theme.dart';

class LoansTab extends ConsumerWidget {
  const LoansTab({super.key, required this.accountId, required this.currencySymbol});

  final String accountId;
  final String currencySymbol;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loansAsync = ref.watch(loansProvider(accountId));

    return Scaffold(
      body: loansAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (loans) {
          if (loans.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.handshake_outlined,
                    size: 64,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No loans yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to add a loan',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: loans.length,
            itemBuilder: (context, index) {
              final loan = loans[index];
              return _LoanCard(
                loan: loan,
                accountId: accountId,
                currencySymbol: currencySymbol,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddLoanSheet(context, ref),
        backgroundColor: AppTheme.primaryGreen,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddLoanSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.backgroundDark,
      builder: (context) => AddLoanSheet(
        accountId: accountId,
        currencySymbol: currencySymbol,
      ),
    );
  }
}

class _LoanCard extends ConsumerWidget {
  const _LoanCard({
    required this.loan,
    required this.accountId,
    required this.currencySymbol,
  });

  final FriendLoan loan;
  final String accountId;
  final String currencySymbol;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactAsync = ref.watch(contactsProvider(accountId));
    final contact = contactAsync.maybeWhen(
      data: (contacts) => contacts.firstWhere(
        (c) => c.id == loan.contactId,
        orElse: () => Contact(
          id: loan.contactId,
          accountId: accountId,
          name: 'Unknown',
        ),
      ),
      orElse: () => Contact(
        id: loan.contactId,
        accountId: accountId,
        name: 'Unknown',
      ),
    );

    final isPositive = loan.net > 0;
    final netAmount = loan.net.abs();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.transparent,
      elevation: 0,
      child: InkWell(
        onTap: () => _showLoanDetail(context, ref, contact),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: AppTheme.glassGradient,
            color: AppTheme.surfaceDarkElevated.withAlpha(235),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppTheme.borderDark.withAlpha(153)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(41),
                blurRadius: 16,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: isPositive
                      ? AppTheme.primaryGradient
                      : const LinearGradient(
                          colors: [Color(0xFFEF4444), Color(0xFFFF7F7F)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isPositive ? Icons.arrow_downward : Icons.arrow_upward,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isPositive ? 'They owe you' : 'You owe them',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$currencySymbol${netAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: isPositive ? AppTheme.primaryTeal : AppTheme.errorRed,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Icon(
                    Icons.chevron_right,
                    color: AppTheme.textSecondary,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLoanDetail(BuildContext context, WidgetRef ref, Contact contact) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.backgroundDark,
      builder: (context) => LoanDetailSheet(
        loan: loan,
        contact: contact,
        accountId: accountId,
        currencySymbol: currencySymbol,
      ),
    );
  }
}

class LoanDetailSheet extends ConsumerWidget {
  const LoanDetailSheet({
    super.key,
    required this.loan,
    required this.contact,
    required this.accountId,
    required this.currencySymbol,
  });

  final FriendLoan loan;
  final Contact contact;
  final String accountId;
  final String currencySymbol;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(loanEventsProvider((accountId: accountId, loanId: loan.id)));
    final isPositive = loan.net > 0;

    return Container(
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: isPositive
                      ? AppTheme.primaryGradient
                      : const LinearGradient(
                          colors: [Color(0xFFEF4444), Color(0xFFFF7F7F)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  borderRadius: BorderRadius.circular(18),
                ),
                alignment: Alignment.center,
                child: Icon(
                  isPositive ? Icons.arrow_downward : Icons.arrow_upward,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      isPositive ? 'They owe you' : 'You owe them',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: isPositive
                  ? AppTheme.primaryGradient
                  : const LinearGradient(
                      colors: [Color(0xFFEF4444), Color(0xFFFF7F7F)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(46),
                  blurRadius: 18,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Net Amount',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$currencySymbol${loan.net.abs().toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  label: 'You Gave',
                  amount: loan.totalYouGave,
                  currencySymbol: currencySymbol,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryCard(
                  label: 'You Took',
                  amount: loan.totalYouTook,
                  currencySymbol: currencySymbol,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Text(
                'Transaction History',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _showAddEventSheet(context, ref);
                },
                icon: const Icon(Icons.add),
                label: const Text('Add'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 300,
            child: eventsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
              data: (events) {
                if (events.isEmpty) {
                  return Center(
                    child: Text(
                      'No transactions yet',
                      style: TextStyle(color: AppTheme.textSecondary),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return _EventCard(
                      event: event,
                      currencySymbol: currencySymbol,
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          if (loan.net != 0)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _markAsPaid(context, ref),
                    icon: const Icon(Icons.check),
                    label: const Text('Mark as Paid'),
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
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _settleLoan(context, ref),
                    icon: const Icon(Icons.payments),
                    label: const Text('Settle & Pay'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.errorRed,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 6,
                      shadowColor: AppTheme.errorRed.withAlpha(76),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _showAddEventSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.backgroundDark,
      builder: (context) => AddLoanEventSheet(
        accountId: accountId,
        loanId: loan.id,
        contactName: contact.name,
        currencySymbol: currencySymbol,
      ),
    );
  }

  Future<void> _markAsPaid(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mark as Paid'),
        content: const Text('This will mark the loan as paid without creating a transaction. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Mark Paid'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final controller = ref.read(loanControllerProvider.notifier);
      await controller.markLoanAsPaid(accountId, loan.id);
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Loan marked as paid')),
        );
      }
    }
  }

  Future<void> _settleLoan(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settle & Pay'),
        content: const Text('This will create a settlement transaction and mark the loan as paid. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Settle & Pay'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final controller = ref.read(loanControllerProvider.notifier);
      await controller.settleLoan(accountId, loan.id);
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Loan settled and transaction created')),
        );
      }
    }
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.amount,
    required this.currencySymbol,
    required this.color,
  });

  final String label;
  final double amount;
  final String currencySymbol;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
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
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$currencySymbol${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({
    required this.event,
    required this.currencySymbol,
  });

  final LoanEvent event;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    final isYouGave = event.type == LoanEventType.youLent;
    final icon = isYouGave ? Icons.arrow_upward : Icons.arrow_downward;
    final color = isYouGave ? AppTheme.primaryTeal : AppTheme.errorRed;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(12),
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
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                gradient: isYouGave
                    ? AppTheme.primaryGradient
                    : const LinearGradient(
                        colors: [Color(0xFFEF4444), Color(0xFFFF7F7F)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getEventLabel(event.type),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    DateFormat('MMM dd, yyyy HH:mm').format(event.createdAt ?? DateTime.now()),
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '$currencySymbol${event.amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getEventLabel(LoanEventType type) {
    switch (type) {
      case LoanEventType.youLent:
        return 'You Gave';
      case LoanEventType.youBorrowed:
        return 'You Took';
      case LoanEventType.repayment:
        return 'Repayment';
      case LoanEventType.settlement:
        return 'Settlement';
    }
  }
}

class AddLoanSheet extends ConsumerStatefulWidget {
  const AddLoanSheet({
    super.key,
    required this.accountId,
    required this.currencySymbol,
  });

  final String accountId;
  final String currencySymbol;

  @override
  ConsumerState<AddLoanSheet> createState() => _AddLoanSheetState();
}

class _AddLoanSheetState extends ConsumerState<AddLoanSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String? _selectedContactId;
  LoanEventType _eventType = LoanEventType.youLent;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contactsAsync = ref.watch(contactsProvider(widget.accountId));

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
                const Text(
                  'Add Loan Transaction',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 24),
                contactsAsync.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stack) => Text('Error: $error'),
                  data: (contacts) {
                    if (contacts.isEmpty) {
                      return const Text('No contacts available. Add a contact first.');
                    }

                    return DropdownButtonFormField<String>(
                        initialValue: _selectedContactId,
                      decoration: InputDecoration(
                        labelText: 'Contact',
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
                      items: contacts.map((contact) {
                        return DropdownMenuItem(
                          value: contact.id,
                          child: Text(contact.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedContactId = value);
                      },
                      validator: (value) {
                        if (value == null) return 'Please select a contact';
                        return null;
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
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
                        label: 'You Gave',
                        icon: Icons.arrow_upward,
                        color: Colors.green,
                        selected: _eventType == LoanEventType.youLent,
                        onTap: () => setState(() => _eventType = LoanEventType.youLent),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _TypeButton(
                        label: 'You Took',
                        icon: Icons.arrow_downward,
                        color: Colors.red,
                        selected: _eventType == LoanEventType.youBorrowed,
                        onTap: () => setState(() => _eventType = LoanEventType.youBorrowed),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    prefixText: '${widget.currencySymbol} ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
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
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Add Transaction'),
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

    final controller = ref.read(loanControllerProvider.notifier);
    final amount = double.parse(_amountController.text);

    // Check if loan exists for this contact
    final loansAsync = ref.read(loansProvider(widget.accountId));
    final loans = loansAsync.value ?? [];
    final existingLoan = loans.where((l) => l.contactId == _selectedContactId!).firstOrNull;

    if (existingLoan != null) {
      // Add event to existing loan
      await controller.addLoanEvent(
        accountId: widget.accountId,
        loanId: existingLoan.id,
        type: _eventType,
        amount: amount,
      );
    } else {
      // Create new loan and add first event
      final newLoan = await controller.createLoan(widget.accountId, _selectedContactId!);
      if (newLoan != null) {
        await controller.addLoanEvent(
          accountId: widget.accountId,
          loanId: newLoan.id,
          type: _eventType,
          amount: amount,
        );
      }
    }

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction added')),
      );
    }
  }
}

class AddLoanEventSheet extends ConsumerStatefulWidget {
  const AddLoanEventSheet({
    super.key,
    required this.accountId,
    required this.loanId,
    required this.contactName,
    required this.currencySymbol,
  });

  final String accountId;
  final String loanId;
  final String contactName;
  final String currencySymbol;

  @override
  ConsumerState<AddLoanEventSheet> createState() => _AddLoanEventSheetState();
}

class _AddLoanEventSheetState extends ConsumerState<AddLoanEventSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  LoanEventType _eventType = LoanEventType.youLent;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  'Add Transaction with ${widget.contactName}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 24),
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
                        label: 'You Gave',
                        icon: Icons.arrow_upward,
                        color: AppTheme.primaryTeal,
                        gradient: AppTheme.primaryGradient,
                        selected: _eventType == LoanEventType.youLent,
                        onTap: () => setState(() => _eventType = LoanEventType.youLent),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _TypeButton(
                        label: 'You Took',
                        icon: Icons.arrow_downward,
                        color: AppTheme.errorRed,
                        gradient: const LinearGradient(
                          colors: [Color(0xFFEF4444), Color(0xFFFF7F7F)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        selected: _eventType == LoanEventType.youBorrowed,
                        onTap: () => setState(() => _eventType = LoanEventType.youBorrowed),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 24),
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
                    child: const Text('Add Transaction'),
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

    final controller = ref.read(loanControllerProvider.notifier);
    final amount = double.parse(_amountController.text);

    await controller.addLoanEvent(
      accountId: widget.accountId,
      loanId: widget.loanId,
      type: _eventType,
      amount: amount,
    );

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction added')),
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
    final showGradient = selected && gradient != null;
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
                    color: color.withAlpha(56),
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
