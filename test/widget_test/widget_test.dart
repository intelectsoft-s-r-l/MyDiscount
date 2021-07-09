// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:my_discount/presentation/app/my_app.dart';

void main() {
  testWidgets(
    'test my app widget',
    (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await Hive.initFlutter();
      await Hive.openBox('locale');
      await tester.pumpWidget(MyApp());

      // Verify that our counter starts at 0.
      expect(find.byType(MaterialApp), findsOneWidget);

      await tester.pumpWidget(SplashScreen());

      expect(find.byType(MaterialApp), findsNothing);
      expect(find.byType(BlocListener), findsOneWidget);

      await tester.pump();

      /*  // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget); */
    },
    skip: true,
  );
}
