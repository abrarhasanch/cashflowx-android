import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/controllers/auth_controller.dart';
import '../../widgets/primary_button.dart';
import '../../providers/settings_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late final TextEditingController currencyController;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authStateChangesProvider).valueOrNull;
    currencyController = TextEditingController(text: user?.defaultCurrency ?? 'USD');
  }

  @override
  void dispose() {
    currencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(authStateChangesProvider);
    final controller = ref.watch(settingsControllerProvider);
    final authController = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (user) {
          if (user == null) {
            return const Center(child: Text('No user data'));
          }
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              ListTile(
                title: Text(user.displayName ?? 'No name'),
                subtitle: Text(user.email),
                leading: const CircleAvatar(child: Icon(Icons.person_outline)),
              ),
              const SizedBox(height: 24),
              Text('Preferred currency', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              TextField(controller: currencyController, decoration: const InputDecoration(labelText: 'Currency code eg. USD')),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Save',
                loading: controller.isLoading,
                onPressed: () => ref.read(settingsControllerProvider.notifier).updateCurrency(user, currencyController.text.trim()),
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                label: 'Sign out',
                loading: authController.isLoading,
                onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
              ),
            ],
          );
        },
      ),
    );
  }
}
