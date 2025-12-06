import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../providers/account_providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/empty_state.dart';

class AccountsListScreen extends ConsumerWidget {
  const AccountsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: const AppDrawer(),
      body: Builder(
        builder: (scaffoldContext) => SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryGreen.withAlpha(71),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      _IconButton(
                        icon: Icons.menu,
                        onTap: () => Scaffold.of(scaffoldContext).openDrawer(),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Accounts',
                              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Manage balances and track cash flows',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white70,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      _IconButton(
                        icon: Icons.add,
                        onTap: () => _showCreateAccountSheet(context, ref, 'BDT'),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 20),

              // Accounts List
              accountsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Text(
                    'Error: $error',
                    style: TextStyle(color: AppTheme.errorRed),
                  ),
                ),
                data: (accounts) {
                  if (accounts.isEmpty) {
                    return EmptyState(
                      icon: Icons.account_balance_wallet_outlined,
                      message: 'No accounts yet',
                      subtitle: 'Create your first account to start tracking',
                      action: ElevatedButton.icon(
                        onPressed: () => _showCreateAccountSheet(context, ref, 'BDT'),
                        icon: const Icon(Icons.add),
                        label: const Text('Create Account'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: accounts.map((account) {
                      final balance = account.totalIn - account.totalOut;
                      final currencySymbol = AppTheme.getCurrencySymbol(account.currency);

                      return _AccountCard(
                        title: account.title,
                        description: account.description ?? '',
                        balance: balance,
                        currencySymbol: currencySymbol,
                        totalIn: account.totalIn,
                        totalOut: account.totalOut,
                        onTap: () => context.go('/accounts/${account.id}'),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ), // closing Column
        ), // closing SingleChildScrollView
      ), // closing SafeArea (arrow function return)
      ), // end of Builder
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateAccountSheet(context, ref, 'BDT'),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('New Account'),
      ),
    ); // end of Scaffold
  }

  void _showCreateAccountSheet(BuildContext context, WidgetRef ref, String defaultCurrency) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _CreateAccountSheet(defaultCurrency: defaultCurrency),
    );
  }
}

class _AccountCard extends StatelessWidget {
  const _AccountCard({
    required this.title,
    required this.description,
    required this.balance,
    required this.currencySymbol,
    required this.totalIn,
    required this.totalOut,
    required this.onTap,
  });

  final String title;
  final String description;
  final double balance;
  final String currencySymbol;
  final double totalIn;
  final double totalOut;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppTheme.glassGradient,
              color: Theme.of(context).cardColor.withAlpha(235),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppTheme.borderDark.withAlpha(153)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(46),
                  blurRadius: 18,
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
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_outlined,
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
                          title,
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            description,
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, color: AppTheme.textSecondary, size: 16),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Balance',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$currencySymbol${NumberFormat('#,##0.00').format(balance)}',
                          style: TextStyle(
                            color: balance >= 0 ? AppTheme.successGreen : AppTheme.errorRed,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 44,
                    color: AppTheme.borderDark.withAlpha(153),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.arrow_downward, color: AppTheme.successGreen, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '$currencySymbol${NumberFormat('#,##0').format(totalIn)}',
                              style: TextStyle(
                                color: AppTheme.successGreen,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.arrow_upward, color: AppTheme.errorRed, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '$currencySymbol${NumberFormat('#,##0').format(totalOut)}',
                              style: TextStyle(
                                color: AppTheme.errorRed,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreateAccountSheet extends ConsumerStatefulWidget {
  const _CreateAccountSheet({required this.defaultCurrency});

  final String defaultCurrency;

  @override
  ConsumerState<_CreateAccountSheet> createState() => _CreateAccountSheetState();
}

class _CreateAccountSheetState extends ConsumerState<_CreateAccountSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  late final _currencyController = TextEditingController(text: widget.defaultCurrency);

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _currencyController.dispose();
    super.dispose();
  }

  Future<void> _createAccount() async {
    if (!_formKey.currentState!.validate()) return;

    final account = await ref.read(accountControllerProvider.notifier).createAccount(
          _titleController.text.trim(),
          _descriptionController.text.trim(),
          _currencyController.text.trim(),
        );

    if (account != null && mounted) {
      Navigator.pop(context);
      context.go('/accounts/${account.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(accountControllerProvider);
    final isLoading = controller.isLoading;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Create New Account',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  color: AppTheme.textSecondary,
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _titleController,
              style: TextStyle(color: AppTheme.textPrimary),
              decoration: InputDecoration(
                labelText: 'Account Name',
                hintText: 'e.g., Main Bank Account',
              ),
              validator: (value) => value?.isEmpty ?? true ? 'Name is required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              style: TextStyle(color: AppTheme.textPrimary),
              decoration: InputDecoration(
                labelText: 'Description (Optional)',
                hintText: 'Add a description',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _currencyController,
              style: TextStyle(color: AppTheme.textPrimary),
              enabled: false,
              decoration: InputDecoration(
                labelText: 'Currency',
                hintText: 'BDT',
              ),
              validator: (value) => value?.isEmpty ?? true ? 'Currency is required' : null,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: isLoading ? null : _createAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withAlpha(230),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.borderDark.withAlpha(153)),
        ),
        child: Icon(icon, color: AppTheme.textPrimary, size: 20),
      ),
    );
  }
}
