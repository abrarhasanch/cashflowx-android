import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../theme/app_theme.dart';
import '../controllers/auth_controller.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo with gradient
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withAlpha(102),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/icons/app_icon.png',
                height: 56,
                width: 56,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'CashFlowX',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              authState.valueOrNull == null ? 'Preparing secure session' : 'Loading your books',
              style: TextStyle(
                color: AppTheme.textMutedDark,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 32),
            if (authState.isLoading)
              LoadingAnimationWidget.newtonCradle(
                color: AppTheme.primaryGreen,
                size: 56,
              ),
          ],
        ),
      ),
    );
  }
}
