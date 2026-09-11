import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bmi_calculator/main.dart';

void main() {
  testWidgets('App root renders without crashing', (tester) async {
    await tester.pumpWidget(const BMICalculatorApp());
    await tester.pump();

    // Unmount the SplashScreen before its 2s timer fires, so the callback
    // short-circuits on `mounted == false` and never touches platform plugins.
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 2100));

    expect(tester.takeException(), isNull);
  });
}
