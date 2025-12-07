import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../accounts/views/account_detail_screen.dart';
import '../accounts/views/accounts_list_screen.dart';
import '../auth/controllers/auth_controller.dart';
import '../auth/views/forgot_password_screen.dart';
import '../auth/views/login_screen.dart';
import '../auth/views/signup_screen.dart';
import '../auth/views/splash_screen.dart';
import '../dashboard/views/dashboard_screen.dart';
import '../due_dates/views/due_date_manager_screen.dart';
import '../reports/views/reports_screen.dart';
import '../settings/views/settings_screen.dart';

// Using authStateChangesProvider from auth_controller.dart

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangesProvider);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final isLoading = authState.isLoading;
      final loggedIn = authState.valueOrNull != null;
      final goingToAuth = state.matchedLocation.startsWith('/auth');
      
      if (isLoading) return null;
      
      if (!loggedIn) {
        return goingToAuth ? null : '/auth/login';
      }
      
      if (goingToAuth || state.matchedLocation == '/') {
        return '/dashboard';
      }
      
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      
      // Auth routes
      GoRoute(
        path: '/auth/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/auth/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      
      // Main app routes
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/accounts',
        builder: (context, state) => AccountsListScreen(
          openCreate: state.uri.queryParameters['create'] == 'true',
        ),
      ),
      GoRoute(
        path: '/accounts/:accountId',
        builder: (context, state) => AccountDetailScreen(
          accountId: state.pathParameters['accountId']!,
        ),
      ),
      GoRoute(
        path: '/due-dates',
        builder: (context, state) => const DueDateManagerScreen(),
      ),
      GoRoute(
        path: '/reports',
        builder: (context, state) => const ReportsScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});
