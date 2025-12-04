import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../auth/controllers/auth_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/empty_state.dart';
import '../../providers/book_providers.dart';
import '../../providers/shelf_providers.dart';

class BooksScreen extends ConsumerWidget {
  const BooksScreen({super.key, required this.shelfId});

  final String shelfId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final books = ref.watch(booksProvider(shelfId));
    final shelves = ref.watch(shelvesProvider);
    final user = ref.watch(authStateChangesProvider).valueOrNull;
    
    final shelf = shelves.valueOrNull?.where((s) => s.id == shelfId).firstOrNull;
    final currency = shelf?.currency ?? 'BDT';
    final currencySymbol = AppTheme.getCurrencySymbol(currency);

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with back button
              Row(
                children: [
                  _BackButton(onTap: () => context.go('/shelves')),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shelf?.title ?? 'Shelf',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          '$currency • ${user?.displayName ?? 'Owner'}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                        ),
                      ],
                    ),
                  ),
                  _IconButton(icon: Icons.settings_outlined, onTap: () {}),
                  const SizedBox(width: 8),
                  _IconButton(icon: Icons.people_outline, onTap: () {}),
                ],
              ),

              const SizedBox(height: 24),

              // Quick Actions - Money In / Money Out / Add Book
              Row(
                children: [
                  Expanded(
                    child: _QuickActionButton(
                      icon: Icons.arrow_downward,
                      label: 'Money In',
                      subtitle: 'Record a receipt',
                      color: AppTheme.successGreen,
                      onTap: () {
                        // TODO: Navigate to add transaction with type cash-in
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _QuickActionButton(
                      icon: Icons.arrow_upward,
                      label: 'Money Out',
                      subtitle: 'Record a payment',
                      color: AppTheme.errorRed,
                      onTap: () {
                        // TODO: Navigate to add transaction with type cash-out
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _QuickActionButton(
                      icon: Icons.add,
                      label: 'Add Book',
                      subtitle: 'New cash book',
                      color: AppTheme.textSecondary,
                      outlined: true,
                      onTap: () => _showCreateBookSheet(context, ref, user?.uid ?? '', currency),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Books Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: AppTheme.cardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Books',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        books.when(
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const SizedBox.shrink(),
                          data: (data) {
                            final total = data.fold<double>(0, (sum, b) => sum + b.totalIn - b.totalOut);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Total Balance',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppTheme.textSecondary,
                                      ),
                                ),
                                Text(
                                  '$currencySymbol ${_formatNumber(total)}',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        color: AppTheme.successGreen,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Books list
                    books.when(
                      loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      error: (error, _) => Center(
                        child: Text('Error: $error', style: TextStyle(color: AppTheme.errorRed)),
                      ),
                      data: (data) {
                        if (data.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: EmptyState(
                              icon: Icons.book_outlined,
                              message: 'No books yet',
                              subtitle: 'Add a book to start tracking transactions',
                              action: ElevatedButton.icon(
                                onPressed: () => _showCreateBookSheet(context, ref, user?.uid ?? '', currency),
                                icon: const Icon(Icons.add, size: 18),
                                label: const Text('Add Book'),
                              ),
                            ),
                          );
                        }
                        return Column(
                          children: data.map((book) {
                            final balance = book.totalIn - book.totalOut;
                            return _BookListItem(
                              title: book.title,
                              balance: '$currencySymbol ${_formatNumber(balance)}',
                              tag: 'Bank',
                              onTap: () => context.go('/shelves/$shelfId/books/${book.id}'),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Recent Transactions Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: AppTheme.cardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Transactions',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.filter_list, size: 18),
                          label: const Text('Filter'),
                          style: TextButton.styleFrom(foregroundColor: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Placeholder for recent transactions
                    Container(
                      padding: const EdgeInsets.all(32),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.receipt_long_outlined, size: 48, color: AppTheme.textSecondary.withOpacity(0.5)),
                            const SizedBox(height: 12),
                            Text(
                              'Select a book to view transactions',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  String _formatNumber(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(2)}M';
    } else if (value >= 1000) {
      return value.toStringAsFixed(2).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );
    }
    return value.toStringAsFixed(2);
  }

  void _showCreateBookSheet(BuildContext context, WidgetRef ref, String ownerUid, String currency) {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final currencyController = TextEditingController(text: currency);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
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
            key: formKey,
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
                
                Text(
                  'Add New Book',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Create a new book to track transactions',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                ),
                const SizedBox(height: 24),
                
                // Book Name
                TextFormField(
                  controller: titleController,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: const InputDecoration(
                    labelText: 'Book Name *',
                    hintText: 'e.g., Cash, Bank, Savings',
                    prefixIcon: Icon(Icons.book_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Book name is required';
                    }
                    if (value.trim().length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                
                // Description
                TextFormField(
                  controller: descriptionController,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                    hintText: 'Notes or details',
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                
                // Currency
                TextFormField(
                  controller: currencyController,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: const InputDecoration(
                    labelText: 'Currency *',
                    hintText: 'e.g., BDT, USD',
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Currency is required';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 32),
                
                // Create Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;
                      
                      Navigator.of(context).pop();
                      
                      final createdBook = await ref.read(bookControllerProvider(shelfId).notifier).createBook(
                            title: titleController.text.trim(),
                            description: descriptionController.text.trim(),
                            ownerUid: ownerUid,
                            currency: currencyController.text.trim().toUpperCase(),
                          );
                      
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              createdBook != null
                                  ? 'Book "${createdBook.title}" created!'
                                  : 'Failed to create book',
                            ),
                            backgroundColor: createdBook != null ? AppTheme.successGreen : AppTheme.errorRed,
                          ),
                        );
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Text('Create Book'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: const Icon(Icons.arrow_back, color: AppTheme.textPrimary, size: 20),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: Icon(icon, color: AppTheme.textSecondary, size: 20),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
    this.outlined = false,
  });
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: outlined ? Colors.transparent : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: outlined ? AppTheme.borderColor : color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: outlined ? AppTheme.surfaceDark : color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: outlined ? AppTheme.textSecondary : color, size: 20),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: outlined ? AppTheme.textPrimary : color,
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: outlined ? AppTheme.textSecondary : color.withOpacity(0.8),
                    fontSize: 10,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _BookListItem extends StatelessWidget {
  const _BookListItem({
    required this.title,
    required this.balance,
    required this.tag,
    required this.onTap,
  });
  final String title;
  final String balance;
  final String tag;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDarkElevated.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.accentPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.book, color: AppTheme.accentPurple, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.accentPurple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          tag,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppTheme.accentPurple,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    balance,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.successGreen,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
          ],
        ),
      ),
    );
  }
}
