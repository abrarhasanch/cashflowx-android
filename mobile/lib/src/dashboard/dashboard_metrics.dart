class DashboardMetrics {
  const DashboardMetrics({
    required this.totalIn,
    required this.totalOut,
    required this.monthlyTotals,
    required this.categoryTotals,
    required this.topContacts,
    required this.activeLoans,
  });

  final double totalIn;
  final double totalOut;
  final Map<String, double> monthlyTotals;
  final Map<String, double> categoryTotals;
  final Map<String, double> topContacts;
  final Map<String, double> activeLoans;

  double get net => totalIn - totalOut;

  DashboardMetrics copyWith({
    double? totalIn,
    double? totalOut,
    Map<String, double>? monthlyTotals,
    Map<String, double>? categoryTotals,
    Map<String, double>? topContacts,
    Map<String, double>? activeLoans,
  }) {
    return DashboardMetrics(
      totalIn: totalIn ?? this.totalIn,
      totalOut: totalOut ?? this.totalOut,
      monthlyTotals: monthlyTotals ?? this.monthlyTotals,
      categoryTotals: categoryTotals ?? this.categoryTotals,
      topContacts: topContacts ?? this.topContacts,
      activeLoans: activeLoans ?? this.activeLoans,
    );
  }

  static DashboardMetrics empty() => const DashboardMetrics(
        totalIn: 0,
        totalOut: 0,
        monthlyTotals: {},
        categoryTotals: {},
        topContacts: {},
        activeLoans: {},
      );
}
