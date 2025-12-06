import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../auth/controllers/auth_controller.dart';
import '../../models/friend_loan.dart';
import '../../models/loan_event.dart';
import '../../providers/loan_providers.dart';
import '../../theme/app_theme.dart';

class LoansTab extends ConsumerWidget {
  const LoansTab({super.key, required this.shelfId, required this.bookId});

  final String shelfId;
  final String bookId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loans = ref.watch(loansProvider((shelfId, bookId)));
    return Container(
      color: AppTheme.backgroundDark,
      child: Stack(
        children: [
          loans.when(
            loading: () => Center(child: CircularProgressIndicator(color: AppTheme.primaryGreen)),
            error: (error, _) => Center(
              child: Text(
                'Error: $error',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            data: (data) {
              if (data.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.handshake_outlined,
                        size: 64,
                        color: AppTheme.textMutedDark,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No friend loans tracked',
                        style: TextStyle(
                          color: AppTheme.textMutedDark,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => _showLoanSheet(context, ref),
                        icon: const Icon(Icons.handshake_outlined),
                        label: const Text('Create Loan'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ...data.map((loan) => _LoanTile(
                        loan: loan,
                        onTap: () => _showLoanDetail(context, ref, loan),
                      )),
                  const SizedBox(height: 80),
                ],
              );
            },
          ),
          Positioned(
            right: 24,
            bottom: 24,
            child: FloatingActionButton.extended(
              onPressed: () => _showLoanSheet(context, ref),
              backgroundColor: AppTheme.primaryGreen,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.handshake_outlined),
              label: const Text('Loan'),
            ),
          ),
        ],
      ),
    );
  }

  void _showLoanSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceDark,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => _LoanSheet(shelfId: shelfId, bookId: bookId),
    );
  }

  void _showLoanDetail(BuildContext context, WidgetRef ref, FriendLoan loan) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceDark,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => LoanDetailSheet(loan: loan),
    );
  }
}

class _LoanTile extends StatelessWidget {
  const _LoanTile({required this.loan, required this.onTap});
  final FriendLoan loan;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final netColor = loan.net >= 0 ? AppTheme.primaryGreen : AppTheme.errorRed;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.borderDark),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      loan.contactId.isNotEmpty ? loan.contactId[0].toUpperCase() : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    loan.contactId,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppTheme.textMutedDark,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'You gave',
                        style: TextStyle(
                          color: AppTheme.textMutedDark,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        loan.totalYouGave.toStringAsFixed(2),
                        style: TextStyle(
                          color: AppTheme.primaryGreen,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'You took',
                        style: TextStyle(
                          color: AppTheme.textMutedDark,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        loan.totalYouTook.toStringAsFixed(2),
                        style: TextStyle(
                          color: AppTheme.errorRed,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Net',
                        style: TextStyle(
                          color: AppTheme.textMutedDark,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        loan.net.toStringAsFixed(2),
                        style: TextStyle(
                          color: netColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoanSheet extends ConsumerStatefulWidget {
  const _LoanSheet({required this.shelfId, required this.bookId});
  final String shelfId;
  final String bookId;

  @override
  ConsumerState<_LoanSheet> createState() => _LoanSheetState();
}

class _LoanSheetState extends ConsumerState<_LoanSheet> {
  final contactController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    contactController.dispose();
    super.dispose();
  }

  InputDecoration _darkInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: AppTheme.textMutedDark),
      filled: true,
      fillColor: AppTheme.cardDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppTheme.borderDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppTheme.borderDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppTheme.primaryGreen, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppTheme.errorRed),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(loanControllerProvider);
    final user = ref.watch(authStateChangesProvider).valueOrNull;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create Loan Pair',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: contactController,
              style: const TextStyle(color: Colors.white),
              decoration: _darkInputDecoration('Contact name *'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Contact name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.isLoading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          final loan = FriendLoan(
                            id: '',
                            shelfId: widget.shelfId,
                            bookId: widget.bookId,
                            contactId: contactController.text.trim(),
                            createdByUid: user?.uid,
                            createdAt: DateTime.now(),
                          );
                          ref.read(loanControllerProvider.notifier).createLoan(loan: loan);
                          Navigator.of(context).pop();
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: controller.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Create',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class LoanDetailSheet extends ConsumerWidget {
  const LoanDetailSheet({super.key, required this.loan});
  final FriendLoan loan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveLoan = ref.watch(loansProvider((loan.shelfId, loan.bookId))).valueOrNull?.firstWhere(
          (item) => item.id == loan.id,
          orElse: () => loan,
        ) ??
        loan;
    final events = ref.watch(loanEventsProvider((loan.shelfId, loan.bookId, loan.id)));
    final controller = ref.watch(loanControllerProvider);
    final netColor = liveLoan.net >= 0 ? AppTheme.primaryGreen : AppTheme.errorRed;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    liveLoan.contactId.isNotEmpty ? liveLoan.contactId[0].toUpperCase() : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      liveLoan.contactId,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Net: ${liveLoan.net.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: netColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: controller.isLoading
                    ? null
                    : () => ref.read(loanControllerProvider.notifier).settleLoan(
                          shelfId: liveLoan.shelfId,
                          bookId: liveLoan.bookId,
                          loanId: liveLoan.id,
                        ),
                child: Text(
                  'Settle',
                  style: TextStyle(color: AppTheme.primaryGreen),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: AppTheme.borderDark),
          events.when(
            loading: () => Padding(
              padding: const EdgeInsets.all(16),
              child: CircularProgressIndicator(color: AppTheme.primaryGreen),
            ),
            error: (error, _) => Text(
              'Error: $error',
              style: const TextStyle(color: Colors.white),
            ),
            data: (data) => SizedBox(
              height: 240,
              child: data.isEmpty
                  ? Center(
                      child: Text(
                        'No events yet',
                        style: TextStyle(color: AppTheme.textMutedDark),
                      ),
                    )
                  : ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final event = data[index];
                        final timestamp = event.createdAt != null ? DateFormat.yMMMd().add_jm().format(event.createdAt!) : '';
                        final isPositive = event.type == LoanEventType.youLent || event.type == LoanEventType.repayment;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.cardDark,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: (isPositive ? AppTheme.primaryGreen : AppTheme.errorRed).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  isPositive ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                                  color: isPositive ? AppTheme.primaryGreen : AppTheme.errorRed,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      event.type.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      timestamp,
                                      style: TextStyle(
                                        color: AppTheme.textMutedDark,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                event.amount.toStringAsFixed(2),
                                style: TextStyle(
                                  color: isPositive ? AppTheme.primaryGreen : AppTheme.errorRed,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showEventSheet(context, ref, liveLoan),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add Event'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEventSheet(BuildContext context, WidgetRef ref, FriendLoan loan) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceDark,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => LoanEventSheet(loan: loan),
    );
  }
}

class LoanEventSheet extends ConsumerStatefulWidget {
  const LoanEventSheet({super.key, required this.loan});
  final FriendLoan loan;

  @override
  ConsumerState<LoanEventSheet> createState() => _LoanEventSheetState();
}

class _LoanEventSheetState extends ConsumerState<LoanEventSheet> {
  final amountController = TextEditingController();
  final noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  LoanEventType type = LoanEventType.youLent;

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  InputDecoration _darkInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: AppTheme.textMutedDark),
      filled: true,
      fillColor: AppTheme.cardDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppTheme.borderDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppTheme.borderDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppTheme.primaryGreen, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppTheme.errorRed),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(loanControllerProvider);
    final user = ref.watch(authStateChangesProvider).valueOrNull;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Loan Event',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            // Event type selector
            Container(
              decoration: BoxDecoration(
                color: AppTheme.cardDark,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      _EventTypeChip(
                        label: 'You Lent',
                        selected: type == LoanEventType.youLent,
                        onTap: () => setState(() => type = LoanEventType.youLent),
                      ),
                      _EventTypeChip(
                        label: 'You Took',
                        selected: type == LoanEventType.youBorrowed,
                        onTap: () => setState(() => type = LoanEventType.youBorrowed),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _EventTypeChip(
                        label: 'Repayment',
                        selected: type == LoanEventType.repayment,
                        onTap: () => setState(() => type = LoanEventType.repayment),
                      ),
                      _EventTypeChip(
                        label: 'Settlement',
                        selected: type == LoanEventType.settlement,
                        onTap: () => setState(() => type = LoanEventType.settlement),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: amountController,
              keyboardType: TextInputType.number,
              enabled: type != LoanEventType.settlement,
              style: const TextStyle(color: Colors.white),
              decoration: _darkInputDecoration(type == LoanEventType.settlement ? 'Amount (auto)' : 'Amount *'),
              validator: type == LoanEventType.settlement
                  ? null
                  : (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Amount is required';
                      }
                      if (double.tryParse(value.trim()) == null) {
                        return 'Enter a valid number';
                      }
                      return null;
                    },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: noteController,
              style: const TextStyle(color: Colors.white),
              decoration: _darkInputDecoration('Note'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.isLoading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          final event = LoanEvent(
                            id: '',
                            loanId: widget.loan.id,
                            shelfId: widget.loan.shelfId,
                            bookId: widget.loan.bookId,
                            type: type,
                            amount: double.tryParse(amountController.text.trim()) ?? 0,
                            createdAt: DateTime.now(),
                            createdByUid: user?.uid,
                            note: noteController.text.trim().isEmpty ? null : noteController.text.trim(),
                          );
                          ref.read(loanControllerProvider.notifier).addLoanEvent(
                                shelfId: widget.loan.shelfId,
                                bookId: widget.loan.bookId,
                                loanId: widget.loan.id,
                                event: event,
                              );
                          Navigator.of(context).pop();
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: controller.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Save Event',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _EventTypeChip extends StatelessWidget {
  const _EventTypeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? AppTheme.primaryGreen.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: selected ? AppTheme.primaryGreen : AppTheme.textMutedDark,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
