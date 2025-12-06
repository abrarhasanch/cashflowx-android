import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme/app_theme.dart';

class CashEntriesTab extends ConsumerWidget {
  const CashEntriesTab({super.key, required this.accountId, required this.currencySymbol});

  final String accountId;
  final String currencySymbol;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Text(
        'Cash Entries Tab - Coming Soon',
        style: TextStyle(color: AppTheme.textPrimary),
      ),
    );
  }
}
