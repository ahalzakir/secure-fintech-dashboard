import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:secure_fintech_dashboard/main.dart';
import 'package:secure_fintech_dashboard/widgets/pay_bill_button.dart';

void main() {
  testWidgets('App renders LockScreen on launch', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: SecureFintechApp(),
      ),
    );

    expect(find.text('SECURE ACCESS'), findsOneWidget);
  });

  testWidgets('PayBillButton morphs without layout overflow', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            child: PayBillButton(
              amount: '3820.50',
              onPay: () async {
                return true;
              },
            ),
          ),
        ),
      ),
    );

    expect(find.text('PAY BILL  •  \$3820.50'), findsOneWidget);

    await tester.tap(find.byType(PayBillButton));
    await tester.pump();
    await tester.pump(const Duration(seconds: 3));

    expect(tester.takeException(), isNull);
  });
}
