import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:share_plus/share_plus.dart';

import '../../transactions/views/transactions_tab.dart';
import '../../contacts/views/contacts_tab.dart';
import '../../loans/views/loans_tab.dart';
import '../../providers/firestore_service_provider.dart';
import '../../theme/app_theme.dart';

class BookWorkspaceScreen extends ConsumerStatefulWidget {
  const BookWorkspaceScreen({super.key, required this.shelfId, required this.bookId});

  final String shelfId;
  final String bookId;

  @override
  ConsumerState<BookWorkspaceScreen> createState() => _BookWorkspaceScreenState();
}

class _BookWorkspaceScreenState extends ConsumerState<BookWorkspaceScreen> with SingleTickerProviderStateMixin {
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
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceDark,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Book Workspace',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share_rounded),
            onPressed: () async {
              final service = ref.read(firestoreServiceProvider);
              final link = await service.generateInviteLink(shelfId: widget.shelfId, bookId: widget.bookId);
              await Share.share('Join my CashFlowX book: $link');
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
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
          tabs: const [
            Tab(text: 'Transactions'),
            Tab(text: 'Contacts'),
            Tab(text: 'Loans'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          TransactionsTab(shelfId: widget.shelfId, bookId: widget.bookId),
          ContactsTab(shelfId: widget.shelfId, bookId: widget.bookId),
          LoansTab(shelfId: widget.shelfId, bookId: widget.bookId),
        ],
      ),
    );
  }
}
