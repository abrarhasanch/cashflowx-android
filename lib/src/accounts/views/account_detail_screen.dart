import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/account.dart';
import '../../providers/account_providers.dart';
import '../../providers/transaction_providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/empty_state.dart';
import '../../services/pdf_service.dart';
import 'tabs/cash_entries_tab.dart';
import 'tabs/members_tab.dart';
import 'tabs/summary_tab.dart';

class AccountDetailScreen extends ConsumerStatefulWidget {
  const AccountDetailScreen({super.key, required this.accountId});

  final String accountId;

  @override
  ConsumerState<AccountDetailScreen> createState() => _AccountDetailScreenState();
}

class _AccountDetailScreenState extends ConsumerState<AccountDetailScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accountAsync = ref.watch(accountDetailProvider(widget.accountId));

    return accountAsync.when(
      loading: () => Scaffold(
        backgroundColor: AppTheme.backgroundDark,
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        backgroundColor: AppTheme.backgroundDark,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $error', style: TextStyle(color: AppTheme.errorRed)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/accounts'),
                child: const Text('Back to Accounts'),
              ),
            ],
          ),
        ),
      ),
      data: (account) {
        if (account == null) {
          return Scaffold(
            backgroundColor: AppTheme.backgroundDark,
            body: Center(
              child: EmptyState(
                icon: Icons.error_outline,
                message: 'Account not found',
                action: ElevatedButton(
                  onPressed: () => context.go('/accounts'),
                  child: const Text('Back to Accounts'),
                ),
              ),
            ),
          );
        }

        final currencySymbol = AppTheme.getCurrencySymbol(account.currency);

        return Scaffold(
          backgroundColor: AppTheme.backgroundDark,
          appBar: AppBar(
            backgroundColor: AppTheme.surfaceDark,
            foregroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.go('/accounts'),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                if (account.description != null && account.description!.isNotEmpty)
                  Text(
                    account.description!,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () {
                  // TODO: Show edit account sheet
                },
              ),
              IconButton(
                icon: const Icon(Icons.picture_as_pdf_outlined),
                onPressed: () => _showExportDialog(account),
                tooltip: 'Export PDF',
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: AppTheme.primaryGreen,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: AppTheme.textMutedDark,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              isScrollable: false,
              tabs: const [
                Tab(text: 'Summary'),
                Tab(text: 'Cash Entries'),
                Tab(text: 'Members'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              SummaryTab(accountId: widget.accountId, currencySymbol: currencySymbol),
              CashEntriesTab(accountId: widget.accountId, currencySymbol: currencySymbol),
              MembersTab(account: account),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showExportDialog(Account account) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          'Export Account Report',
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
        content: Text(
          'Generate PDF report for ${account.title}?\n\nThe report will include:\n• Account summary\n• Transaction history\n• Balance information',
          style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGreen,
            ),
            child: const Text('Export PDF'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _generatePdf(account);
    }
  }

  Future<void> _generatePdf(Account account) async {
    try {
      // Show loading indicator
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Generating PDF...',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Get transactions for this account
      final transactions = await ref.read(
        transactionsProvider(widget.accountId).future,
      );

      // Generate PDF for single account
      await PdfService.generateAndShareReport(
        accounts: [account],
        transactionsByAccount: {account.id: transactions},
        startDate: DateTime.now().subtract(const Duration(days: 365)),
        endDate: DateTime.now(),
        currency: account.currency,
      );

      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PDF generated successfully!'),
            backgroundColor: AppTheme.successGreen,
          ),
        );
      }
    } catch (e) {
      // Close loading dialog
      if (mounted) {
        Navigator.of(context).pop();
        
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate PDF: $e'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    }
  }
}
