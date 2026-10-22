import 'dart:async';
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
    final completer = Completer<bool>();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            child: PayBillButton(
              amount: '3820.50',
              onPay: () => completer.future,
            ),
          ),
        ),
      ),
    );

    expect(find.text('PAY BILL  •  \$3820.50'), findsOneWidget);

    await tester.tap(find.byType(PayBillButton));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    completer.complete(true);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('PAY BILL  •  \$3820.50'), findsOneWidget);

    expect(tester.takeException(), isNull);
  });

  testWidgets('PayBillButton displays error state when onPay returns false and remains tappable', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            child: PayBillButton(
              amount: '3820.50',
              onPay: () async => false,
            ),
          ),
        ),
      ),
    );

    expect(find.text('PAY BILL  •  \$3820.50'), findsOneWidget);

    await tester.tap(find.byType(PayBillButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('FAILED - TAP TO RETRY'), findsOneWidget);
    expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);

    final inkWell = tester.widget<InkWell>(find.byType(InkWell));
    expect(inkWell.onTap, isNotNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('PayBillButton catches onPay exceptions without throwing and displays error state', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            child: PayBillButton(
              amount: '3820.50',
              onPay: () async {
                throw Exception('Payment gateway timeout');
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(PayBillButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('FAILED - TAP TO RETRY'), findsOneWidget);
    expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('PayBillButton retries after failure and recovers on subsequent success', (WidgetTester tester) async {
    int callCount = 0;
    Completer<bool>? secondCompleter;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            child: PayBillButton(
              amount: '3820.50',
              onPay: () async {
                callCount++;
                if (callCount == 1) {
                  return false;
                } else {
                  secondCompleter = Completer<bool>();
                  return secondCompleter!.future;
                }
              },
            ),
          ),
        ),
      ),
    );

    // Initial attempt -> fails
    await tester.tap(find.byType(PayBillButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('FAILED - TAP TO RETRY'), findsOneWidget);
    expect(callCount, 1);

    // Tap retry -> transitions to loading
    await tester.tap(find.byType(PayBillButton));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(callCount, 2);

    // Second attempt resolves true -> transitions to success
    secondCompleter!.complete(true);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);

    // Reverts to idle after 2s hold
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('PAY BILL  •  \$3820.50'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
