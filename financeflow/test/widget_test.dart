import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:financeflow/main.dart';

void main() {
  testWidgets('App root widget and dashboard rendered', (WidgetTester tester) async {
    await tester.pumpWidget(const FinanceFlowApp());

    // The dashboard title should show by default.
    expect(find.text('Dashboard'), findsOneWidget);

    // There should be a summary card with the Total Balance.
    expect(find.text('Total Balance'), findsOneWidget);

    // Find the Recent Transactions label.
    expect(find.text('Recent Transactions'), findsOneWidget);

    // There should be at least one table row for transactions.
    expect(find.byType(DataTable), findsOneWidget);
  });

  testWidgets('Navigation bar switches pages', (WidgetTester tester) async {
    await tester.pumpWidget(const FinanceFlowApp());

    // Initially, dashboard is selected.
    expect(find.text('Dashboard'), findsOneWidget);

    // Navigate to Budgets tab
    await tester.tap(find.byIcon(Icons.account_balance_wallet_rounded));
    await tester.pump();

    expect(find.text('Budgets'), findsOneWidget);

    // Navigate to Reports tab
    await tester.tap(find.byIcon(Icons.analytics_rounded));
    await tester.pump();

    expect(find.text('Reports'), findsOneWidget);
  });
}
