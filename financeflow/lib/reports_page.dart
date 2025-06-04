import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// PUBLIC_INTERFACE
class ReportsPage extends StatelessWidget {
  /// The main Reports page showing analytics, mock charts and summary widgets.
  /// Follows the app's theme and is ready for future extensions.
  const ReportsPage({super.key});

  // Theme colors as per FinanceFlow app
  static const primaryColor = Color(0xFF2E86AB);
  static const secondaryColor = Color(0xFFF6F7EB);
  static const accentColor = Color(0xFFF26419);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor,
      ),
      backgroundColor: secondaryColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildSummaryCards(),
            const SizedBox(height: 20),
            _buildChartsSection(),
            const SizedBox(height: 24),
            _buildFutureExtensionPlaceholder(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    // Mock data for summaries
    final totalIncome = 4200.0;
    final totalExpense = 2780.0;
    final netSavings = 1420.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _SummaryCard(
          title: "Income",
          value: "\$${totalIncome.toStringAsFixed(2)}",
          icon: Icons.arrow_downward,
          color: Colors.green.shade400,
        ),
        _SummaryCard(
          title: "Expenses",
          value: "\$${totalExpense.toStringAsFixed(2)}",
          icon: Icons.arrow_upward,
          color: Colors.red.shade400,
        ),
        _SummaryCard(
          title: "Savings",
          value: "\$${netSavings.toStringAsFixed(2)}",
          icon: Icons.savings,
          color: accentColor,
        ),
      ],
    );
  }

  Widget _buildChartsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Spending Trend", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: primaryColor)),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: Card(
            color: Colors.white,
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: LineChart(
                LineChartData(
                  backgroundColor: Colors.white,
                  gridData: FlGridData(show: true, horizontalInterval: 500),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) => Text(_monthFromValue(value)),
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 500,
                        getTitlesWidget: (value, meta) => Text('\$${value.toInt()}'),
                        reservedSize: 40,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: 5,
                  minY: 0,
                  maxY: 3000,
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 1200),
                        FlSpot(1, 1600),
                        FlSpot(2, 1500),
                        FlSpot(3, 2200),
                        FlSpot(4, 1850),
                        FlSpot(5, 2780),
                      ],
                      isCurved: true,
                      color: accentColor,
                      barWidth: 4,
                      dotData: FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text("Expense Breakdown", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: primaryColor)),
        const SizedBox(height: 8),
        SizedBox(
          height: 180,
          child: Card(
            color: Colors.white,
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 35,
                  sections: [
                    PieChartSectionData(
                      value: 1050,
                      color: accentColor,
                      title: 'Bills',
                      titleStyle: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    PieChartSectionData(
                      value: 700,
                      color: primaryColor,
                      title: 'Groceries',
                      titleStyle: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    PieChartSectionData(
                      value: 400,
                      color: Colors.amber,
                      title: 'Leisure',
                      titleStyle: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    PieChartSectionData(
                      value: 630,
                      color: Colors.teal,
                      title: 'Rent',
                      titleStyle: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
                  sectionsSpace: 4,
                  startDegreeOffset: -90,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFutureExtensionPlaceholder() {
    return Container(
      padding: const EdgeInsets.all(22),
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: primaryColor.withAlpha((0.07 * 255).round()),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: const [
          Icon(Icons.filter_alt, color: primaryColor),
          SizedBox(width: 10),
          Text(
            "Filter and detailed widgets coming soon...",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: primaryColor
            ),
          ),
        ],
      ),
    );
  }

  static String _monthFromValue(double value) {
    // Helper for showing month labels on the chart axis
    const labels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
    int ix = value.toInt();
    if (ix < 0 || ix >= labels.length) return '';
    return labels[ix];
  }
}

/// Card widget for summary info
class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withAlpha((0.1 * 255).round()),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: SizedBox(
        width: 100,
        height: 95,
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 28),
              Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 16)),
              Text(title, style: TextStyle(color: color, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}
