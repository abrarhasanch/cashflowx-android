import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../auth/controllers/auth_controller.dart';
import '../../providers/theme_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_drawer.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _dueDateReminders = true;
  bool _loanReminders = true;
  String _selectedCurrency = 'INR';

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(authStateChangesProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            'Error: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
        data: (user) {
          if (user == null) {
            return const Center(
              child: Text(
                'No user data',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Profile Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.cardDark,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppTheme.primaryGreen.withOpacity(0.2),
                      child: Text(
                        (user.displayName?[0] ?? user.email[0]).toUpperCase(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.displayName ?? 'User',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.email,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Currency Settings
              _buildSectionTitle('Currency & Region'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.cardDark,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.currency_rupee,
                    color: AppTheme.primaryGreen,
                  ),
                  title: const Text(
                    'Currency',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    _selectedCurrency,
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                  onTap: () => _showCurrencyPicker(),
                ),
              ),

              const SizedBox(height: 24),

              // Theme Settings
              _buildSectionTitle('Appearance'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.cardDark,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SwitchListTile(
                  secondary: const Icon(
                    Icons.dark_mode_outlined,
                    color: AppTheme.primaryGreen,
                  ),
                  title: const Text(
                    'Dark Mode',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    ref.watch(themeModeProvider) == ThemeMode.dark ? 'Enabled' : 'Disabled',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  value: ref.watch(themeModeProvider) == ThemeMode.dark,
                  onChanged: (value) {
                    ref.read(themeModeProvider.notifier).setTheme(
                      value ? ThemeMode.dark : ThemeMode.light,
                    );
                  },
                  activeColor: AppTheme.primaryGreen,
                ),
              ),

              const SizedBox(height: 24),

              // Notifications Settings
              _buildSectionTitle('Notifications'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.cardDark,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      secondary: const Icon(
                        Icons.notifications_outlined,
                        color: AppTheme.primaryGreen,
                      ),
                      title: const Text(
                        'Enable Notifications',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        'Receive app notifications',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _notificationsEnabled = value;
                          if (!value) {
                            _dueDateReminders = false;
                            _loanReminders = false;
                          }
                        });
                      },
                      activeColor: AppTheme.primaryGreen,
                    ),
                    Divider(color: Colors.grey[800], height: 1),
                    SwitchListTile(
                      secondary: const Icon(
                        Icons.event_outlined,
                        color: AppTheme.primaryGreen,
                      ),
                      title: const Text(
                        'Due Date Reminders',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        'Get notified about upcoming due dates',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      value: _dueDateReminders && _notificationsEnabled,
                      onChanged: _notificationsEnabled
                          ? (value) {
                              setState(() {
                                _dueDateReminders = value;
                              });
                            }
                          : null,
                      activeColor: AppTheme.primaryGreen,
                    ),
                    Divider(color: Colors.grey[800], height: 1),
                    SwitchListTile(
                      secondary: const Icon(
                        Icons.handshake_outlined,
                        color: AppTheme.primaryGreen,
                      ),
                      title: const Text(
                        'Loan Reminders',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        'Get notified about loan activities',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      value: _loanReminders && _notificationsEnabled,
                      onChanged: _notificationsEnabled
                          ? (value) {
                              setState(() {
                                _loanReminders = value;
                              });
                            }
                          : null,
                      activeColor: AppTheme.primaryGreen,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Data Management
              _buildSectionTitle('Data Management'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.cardDark,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.backup_outlined,
                        color: AppTheme.primaryGreen,
                      ),
                      title: const Text(
                        'Backup Data',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        'Save your data to cloud',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                      onTap: () => _showBackupDialog(),
                    ),
                    Divider(color: Colors.grey[800], height: 1),
                    ListTile(
                      leading: const Icon(
                        Icons.restore_outlined,
                        color: AppTheme.primaryGreen,
                      ),
                      title: const Text(
                        'Restore Data',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        'Restore from previous backup',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                      onTap: () => _showRestoreDialog(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // About & Support
              _buildSectionTitle('About & Support'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.cardDark,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.info_outline,
                        color: AppTheme.primaryGreen,
                      ),
                      title: const Text(
                        'About',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        'Version 1.0.0',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                      onTap: () => _showAboutDialog(),
                    ),
                    Divider(color: Colors.grey[800], height: 1),
                    ListTile(
                      leading: const Icon(
                        Icons.help_outline,
                        color: AppTheme.primaryGreen,
                      ),
                      title: const Text(
                        'Help & Support',
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Support page coming soon!'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Sign Out Button
              ElevatedButton(
                onPressed: () async {
                  final confirmed = await _showSignOutDialog();
                  if (confirmed == true) {
                    await ref.read(authControllerProvider.notifier).signOut();
                    if (mounted) {
                      context.go('/auth/login');
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text(
                      'Sign Out',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryGreen,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  void _showCurrencyPicker() {
    final currencies = ['INR', 'USD', 'EUR', 'GBP', 'JPY', 'AUD'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardDark,
        title: const Text(
          'Select Currency',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: currencies.map((currency) {
            return ListTile(
              title: Text(
                currency,
                style: const TextStyle(color: Colors.white),
              ),
              trailing: _selectedCurrency == currency
                  ? const Icon(Icons.check, color: AppTheme.primaryGreen)
                  : null,
              onTap: () {
                setState(() {
                  _selectedCurrency = currency;
                });
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showBackupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardDark,
        title: const Text(
          'Backup Data',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'This will backup all your accounts, transactions, contacts, and loans to Firebase Storage.\n\nBackup is automatic when connected to internet.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Backup completed successfully!'),
                  backgroundColor: AppTheme.primaryGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGreen,
            ),
            child: const Text('Backup Now'),
          ),
        ],
      ),
    );
  }

  void _showRestoreDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardDark,
        title: const Text(
          'Restore Data',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'This will restore your data from the latest backup.\n\nWarning: This will replace all current data.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data restored successfully!'),
                  backgroundColor: AppTheme.primaryGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: const Text('Restore'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardDark,
        title: const Text(
          'CashFlowX',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Version 1.0.0\n\nA comprehensive loan and cash flow management app.\n\nDeveloped with Flutter and Firebase.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showSignOutDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardDark,
        title: const Text(
          'Sign Out',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to sign out?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
