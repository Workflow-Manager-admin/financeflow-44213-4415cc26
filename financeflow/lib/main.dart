import 'package:flutter/material.dart';

void main() {
  runApp(const FinanceFlowApp());
}

/// PUBLIC_INTERFACE
/// The root of the FinanceFlow application. Sets up theming and home screen.
class FinanceFlowApp extends StatelessWidget {
  const FinanceFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF2E86AB);
    final Color secondaryColor = const Color(0xFFF6F7EB);
    final Color accentColor = const Color(0xFFF26419);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FinanceFlow',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: primaryColor,
        colorScheme: ColorScheme.light(
          primary: primaryColor,
          secondary: accentColor,
          surface: secondaryColor,
        ),
        scaffoldBackgroundColor: secondaryColor,
        appBarTheme: AppBarTheme(
          surfaceTintColor: primaryColor,
          foregroundColor: Colors.white,
        ),
        cardColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: accentColor,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: const MainContainer(),
    );
  }
}

/// PUBLIC_INTERFACE
/// The main container for the FinanceFlow app.
/// Includes dashboard, budgets, and reports navigation,
/// and lays groundwork for all main features.
class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const DashboardPage(),
    BudgetManagementPage(),
    Placeholder(
      fallbackHeight: double.infinity,
      fallbackWidth: double.infinity,
      color: Colors.deepOrange,
      strokeWidth: 2,
    ), // ReportsPage (to be implemented)
  ];

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<String> _titles = [
    'Dashboard',
    'Budgets',
    'Reports',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        elevation: 0,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_rounded),
            label: 'Budgets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_rounded),
            label: 'Reports',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: _onNavTapped,
      ),
    );
  }
}

/// PUBLIC_INTERFACE
/// The Budgets Management Page allows users to add, edit, and delete budget categories with amounts.
/// The UI updates live as changes are made.
class BudgetManagementPage extends StatefulWidget {
  BudgetManagementPage({super.key});

  @override
  State<BudgetManagementPage> createState() => _BudgetManagementPageState();
}

class _BudgetManagementPageState extends State<BudgetManagementPage> {
  List<_BudgetItem> _budgets = [
    _BudgetItem(category: "Food", amount: 400.0),
    _BudgetItem(category: "Utilities", amount: 170.0),
    _BudgetItem(category: "Entertainment", amount: 150.0),
  ];

  void _addBudget() async {
    final result = await showDialog<_BudgetItem>(
      context: context,
      builder: (context) => _BudgetDialog(),
    );
    if (result != null) {
      setState(() {
        _budgets.add(result);
      });
    }
  }

  void _editBudget(int idx) async {
    final result = await showDialog<_BudgetItem>(
      context: context,
      builder: (context) => _BudgetDialog(
        initialCategory: _budgets[idx].category,
        initialAmount: _budgets[idx].amount,
      ),
    );
    if (result != null) {
      setState(() {
        _budgets[idx] = result;
      });
    }
  }

  void _deleteBudget(int idx) async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Budget"),
        content: const Text("Are you sure you want to delete this budget category?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          )
        ],
      ),
    );
    if (confirmed == true) {
      setState(() {
        _budgets.removeAt(idx);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color accentColor = Theme.of(context).colorScheme.secondary;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Budgets",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                ),
                onPressed: _addBudget,
                label: const Text("Add Budget"),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Expanded(
            child: _budgets.isEmpty
                ? Center(
                    child: Text(
                      "No budgets set. Add a category!",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  )
                : Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: _budgets.length,
                      separatorBuilder: (ctx, idx) => Divider(height: 2),
                      itemBuilder: (ctx, idx) {
                        final bud = _budgets[idx];
                        return ListTile(
                          title: Text(bud.category),
                          subtitle: Text("\$${bud.amount.toStringAsFixed(2)}"),
                          leading: const Icon(Icons.folder, color: Colors.blue),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: "Edit",
                                icon: Icon(Icons.edit, color: Colors.grey[800]),
                                onPressed: () => _editBudget(idx),
                              ),
                              IconButton(
                                  tooltip: "Delete",
                                  icon: Icon(Icons.delete, color: Colors.redAccent),
                                  onPressed: () => _deleteBudget(idx)
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          )
        ],
      ),
    );
  }
}

// PRIVATE: Represents a budget category + amount.
class _BudgetItem {
  final String category;
  final double amount;

  _BudgetItem({required this.category, required this.amount});
}

// PUBLIC_INTERFACE
// Dialog for adding/editing a budget category.
class _BudgetDialog extends StatefulWidget {
  final String? initialCategory;
  final double? initialAmount;

  const _BudgetDialog({this.initialCategory, this.initialAmount});

  @override
  State<_BudgetDialog> createState() => _BudgetDialogState();
}

class _BudgetDialogState extends State<_BudgetDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _categoryController;
  late TextEditingController _amountController;

  @override
  void initState() {
    _categoryController = TextEditingController(text: widget.initialCategory ?? "");
    _amountController = TextEditingController(
      text: widget.initialAmount != null ? widget.initialAmount!.toStringAsFixed(2) : "",
    );
    super.initState();
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final cat = _categoryController.text.trim();
      final amt = double.tryParse(_amountController.text.trim());
      if (cat.isNotEmpty && amt != null && amt >= 0) {
        Navigator.of(context).pop(_BudgetItem(category: cat, amount: amt));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialCategory == null ? "Add Budget" : "Edit Budget"),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 260,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: "Category",
                ),
                validator: (val) =>
                  val == null || val.trim().isEmpty ? "Please enter category" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: "Amount (\$)",
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (val) {
                  final amt = double.tryParse(val ?? "");
                  if (amt == null || amt < 0) return "Enter a valid positive number";
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: _submit,
          child: Text(widget.initialCategory == null ? "Add" : "Save"),
        ),
      ],
    );
  }
}

/// PUBLIC_INTERFACE
/// Dashboard Page - shows finance summary, chart analytics, and transactions table.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color accentColor = Theme.of(context).colorScheme.secondary;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Cards row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SummaryCard(
                title: "Total Balance",
                value: "\$12,450",
                icon: Icons.account_balance_wallet,
                color: primaryColor,
              ),
              _SummaryCard(
                title: "This Month's Expenses",
                value: "\$2,104",
                icon: Icons.trending_down,
                color: Colors.redAccent,
              ),
              _SummaryCard(
                title: "Income",
                value: "\$4,800",
                icon: Icons.trending_up,
                color: accentColor,
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Analytics Chart section (placeholder)
          Text('Analytics', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          _ChartPlaceholder(),
          const SizedBox(height: 24),
          // Transactions Table
          Text('Recent Transactions', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          _TransactionsTable(),
        ],
      ),
    );
  }
}

/// PRIVATE_HELPER
/// Widget to represent a summary card at the top of the dashboard.
class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(right: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 105,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: color.withAlpha((0.13 * 255).round()),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 10),
            Text(value,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}

/// PRIVATE_HELPER
/// Placeholder chart. Replace with actual chart widget in future work.
class _ChartPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Center(
        child: Text(
          'Chart Section\n(WIP - Analytics Dashboard)',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade500),
        ),
      ),
    );
  }
}

/// PRIVATE_HELPER
/// Transactions table. Shows recent transactions in tabular format.
class _TransactionsTable extends StatelessWidget {
  final List<Map<String, dynamic>> _transactions = const [
    {
      'type': 'Expense',
      'description': 'Groceries',
      'amount': -84.50,
      'category': 'Food',
      'date': '2024-06-07'
    },
    {
      'type': 'Income',
      'description': 'Part-time Job',
      'amount': 250.00,
      'category': 'Salary',
      'date': '2024-06-06'
    },
    {
      'type': 'Expense',
      'description': 'Internet Bill',
      'amount': -60.00,
      'category': 'Utilities',
      'date': '2024-06-05'
    },
    {
      'type': 'Expense',
      'description': 'Movie Night',
      'amount': -30.00,
      'category': 'Entertainment',
      'date': '2024-06-04'
    },
    {
      'type': 'Income',
      'description': 'Gift',
      'amount': 120.00,
      'category': 'Gift',
      'date': '2024-06-02'
    },
  ];

  const _TransactionsTable();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(Colors.grey.shade200),
        columns: const [
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Desc')),
          DataColumn(label: Text('Category')),
          DataColumn(label: Text('Amount')),
        ],
        rows: _transactions.map((tx) {
          final isIncome = tx['amount'] >= 0;
          return DataRow(
            cells: [
              DataCell(Text(
                tx['date'],
                style: const TextStyle(fontSize: 13),
              )),
              DataCell(Text(
                tx['description'],
                style: const TextStyle(fontSize: 13),
              )),
              DataCell(Text(
                tx['category'],
                style: const TextStyle(fontSize: 13),
              )),
              DataCell(Text(
                '${isIncome ? '+' : ''}\$${tx['amount'].toStringAsFixed(2)}',
                style: TextStyle(
                  color: isIncome ? Colors.green : Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              )),
            ],
          );
        }).toList(),
      ),
    );
  }
}
