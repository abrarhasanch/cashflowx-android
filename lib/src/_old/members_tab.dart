import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme/app_theme.dart';

class MembersTab extends ConsumerWidget {
  const MembersTab({super.key, required this.accountId});

  final String accountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Text(
        'Members Tab - Coming Soon',
        style: TextStyle(color: AppTheme.textPrimary),
      ),
    );
  }
}
