import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../auth/controllers/auth_controller.dart';
import '../../models/account.dart';
import '../../providers/account_providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_drawer.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider).valueOrNull;
    final accountsAsync = ref.watch(accountsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: const AppDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Builder(
                        builder: (context) => _IconButton(
                          icon: Icons.menu,
                          onTap: () => Scaffold.of(context).openDrawer(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dashboard',
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Welcome back, ${user?.displayName ?? 'User'}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _IconButton(
                        icon: Icons.notifications_outlined,
                        onTap: () => context.go('/due-dates'),
                      ),
                      const SizedBox(width: 8),
                      _IconButton(
                        icon: Icons.settings_outlined,
                        onTap: () => context.go('/settings'),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Total Cash In and Cash Out Cards
              accountsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text('Error: $error')),
                data: (accounts) {
                  final totalIn = accounts.fold<double>(0, (sum, acc) => sum + acc.totalIn);
                  final totalOut = accounts.fold<double>(0, (sum, acc) => sum + acc.totalOut);
                  final netBalance = totalIn - totalOut;
                  
                  // Get currency from first account or use default
                  // Always use BDT
                  final currencySymbol = '৳';

                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _SummaryCard(
                              title: 'Cash In',
                              amount: totalIn,
                              currencySymbol: currencySymbol,
                              icon: Icons.south_west_rounded,
                              color: AppTheme.primaryTeal,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _SummaryCard(
                              title: 'Cash Out',
                              amount: totalOut,
                              currencySymbol: currencySymbol,
                              icon: Icons.north_east_rounded,
                              color: AppTheme.errorRed,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      _NetBalanceCard(netBalance: netBalance, currencySymbol: currencySymbol),

                      const SizedBox(height: 24),

                      // Quick Actions Row
                      Row(
                        children: [
                          Expanded(
                            child: _QuickActionCard(
                              title: 'Due Dates',
                              icon: Icons.calendar_today_outlined,
                              onTap: () => context.go('/due-dates'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _QuickActionCard(
                              title: 'Reports',
                              icon: Icons.assessment_outlined,
                              onTap: () => context.go('/reports'),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),
                      const _QuickAddAccountButton(),

                      const SizedBox(height: 24),

                      // Loan Summary Section
                      _LoanPositionSection(accounts: accounts),

                      const SizedBox(height: 24),

                      // Accounts List Section
                      _AccountsListSection(accounts: accounts),

                      const SizedBox(height: 24),

                      // Charts Overview
                      _ChartsOverviewSection(accounts: accounts),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.currencySymbol,
    required this.icon,
    required this.color,
  });

  final String title;
  final double amount;
  final String currencySymbol;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppTheme.glassGradient,
        color: Theme.of(context).cardColor.withAlpha(230),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.borderDark.withAlpha(153)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(38),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$currencySymbol${NumberFormat('#,##0.00').format(amount)}',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _NetBalanceCard extends StatelessWidget {
  const _NetBalanceCard({required this.netBalance, required this.currencySymbol});

  final double netBalance;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGreen.withAlpha(89),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Net Balance',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$currencySymbol${NumberFormat('#,##0.00').format(netBalance)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(46),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoanPositionSection extends ConsumerWidget {
  const _LoanPositionSection({required this.accounts});

  final List<Account> accounts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<Map<String, double>>(
      future: _calculateLoanPositions(ref),
      builder: (context, snapshot) {
        final iOwe = snapshot.data?['iOwe'] ?? 0.0;
        final theyOwe = snapshot.data?['theyOwe'] ?? 0.0;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: AppTheme.glassGradient,
            color: Theme.of(context).cardColor.withAlpha(230),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppTheme.borderDark.withAlpha(153)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(38),
                blurRadius: 20,
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
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryGreen.withAlpha(71),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.handshake_outlined, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Loan Summary',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.errorRed.withAlpha(20),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.errorRed.withAlpha(51)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'I Owe',
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '৳${NumberFormat('#,##0.00').format(iOwe)}',
                            style: TextStyle(
                              color: AppTheme.errorRed,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.successGreen.withAlpha(20),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.successGreen.withAlpha(64)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'They Owe',
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '৳${NumberFormat('#,##0.00').format(theyOwe)}',
                            style: TextStyle(
                              color: AppTheme.successGreen,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<Map<String, double>> _calculateLoanPositions(WidgetRef ref) async {
    double iOwe = 0.0;
    double theyOwe = 0.0;

    // Calculate based on account balances (totalIn - totalOut)
    for (final account in accounts) {
      final balance = account.totalIn - account.totalOut;
      
      if (balance > 0) {
        // Positive balance means I received more than I gave = I Owe
        iOwe += balance;
      } else if (balance < 0) {
        // Negative balance means I gave more than I received = They Owe
        theyOwe += balance.abs();
      }
    }

    return {'iOwe': iOwe, 'theyOwe': theyOwe};
  }
}

class _QuickAddAccountButton extends StatelessWidget {
  const _QuickAddAccountButton();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go('/accounts?create=true'),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: AppTheme.glassGradient,
          color: Theme.of(context).cardColor.withAlpha(235),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.borderDark.withAlpha(153)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(31),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryGreen.withAlpha(76),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Add Account',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Create a new account to track transactions',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: AppTheme.textSecondary, size: 16),
          ],
        ),
      ),
    );
  }
}

class _ChartsOverviewSection extends StatelessWidget {
  const _ChartsOverviewSection({required this.accounts});

  final List<Account> accounts;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.glassGradient,
        color: Theme.of(context).cardColor.withAlpha(235),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.borderDark.withAlpha(153)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(38),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryGreen.withAlpha(71),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.bar_chart_rounded, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Charts Overview',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => context.go('/reports'),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: accounts.isEmpty
                ? Center(
                    child: Text(
                      'No data available',
                      style: TextStyle(color: AppTheme.textSecondary),
                    ),
                  )
                : _buildSimpleBarChart(accounts),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleBarChart(List<Account> accounts) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: accounts.fold<double>(0, (max, acc) => acc.totalIn > max ? acc.totalIn : max) * 1.2,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value < 0 || value >= accounts.length) return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    accounts[value.toInt()].title.length > 8
                        ? '${accounts[value.toInt()].title.substring(0, 8)}...'
                        : accounts[value.toInt()].title,
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  '৳${(value / 1000).toStringAsFixed(0)}k',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1000,
          getDrawingHorizontalLine: (value) => FlLine(
            color: AppTheme.borderDark,
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: accounts.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value.totalIn,
                color: AppTheme.successGreen,
                width: 16,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: AppTheme.glassGradient,
          color: Theme.of(context).cardColor.withAlpha(230),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.borderDark.withAlpha(153)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(31),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryGreen.withAlpha(71),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountsListSection extends StatelessWidget {
  const _AccountsListSection({required this.accounts});

  final List<Account> accounts;

  @override
  Widget build(BuildContext context) {
    if (accounts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'My Accounts',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => context.go('/accounts'),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...accounts.take(5).map((account) {
          final balance = account.totalIn - account.totalOut;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () => context.go('/accounts/${account.id}'),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: AppTheme.glassGradient,
                  color: Theme.of(context).cardColor.withAlpha(235),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.borderDark.withAlpha(153)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(31),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryGreen.withAlpha(64),
                            blurRadius: 14,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        account.title[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            account.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${account.members.length} members',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '৳${balance.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: balance >= 0 ? AppTheme.primaryGreen : Colors.red[400],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          balance >= 0 ? 'Balance' : 'Deficit',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
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
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppTheme.textPrimary, size: 20),
      ),
    );
  }
}
