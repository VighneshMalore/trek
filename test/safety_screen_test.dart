import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trekplanner/data/mock/trek_data.dart';
import 'package:trekplanner/screens/discover/trek_details_screen.dart';
import 'package:trekplanner/screens/safety/safety_screen.dart';

void main() {
  final testTrek = mockTreks.first;

  testWidgets('SafetyScreen displays all required content in verbatim order',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: SafetyScreen(trek: testTrek),
      ),
    );

    // 1. Header
    expect(find.text('Safety'), findsOneWidget);
    expect(find.text('Stay prepared. Stay safe.'), findsOneWidget);
    expect(find.text('For ${testTrek.name}'), findsOneWidget);

    // 2. Emergency Contacts in order
    expect(find.text('Emergency Contacts'), findsOneWidget);
    expect(find.text('Emergency'), findsOneWidget);
    expect(find.text('112'), findsOneWidget);
    expect(find.text('Police'), findsOneWidget);
    expect(find.text('100'), findsOneWidget);
    expect(find.text('Ambulance'), findsOneWidget);
    expect(find.text('108'), findsOneWidget);
    expect(find.text('Fire'), findsOneWidget);
    expect(find.text('101'), findsOneWidget);
    expect(find.text('Call'), findsNWidgets(4));

    // Verify Semantics labels
    expect(find.bySemanticsLabel('Call Emergency 112'), findsOneWidget);
    expect(find.bySemanticsLabel('Call Police 100'), findsOneWidget);
    expect(find.bySemanticsLabel('Call Ambulance 108'), findsOneWidget);
    expect(find.bySemanticsLabel('Call Fire 101'), findsOneWidget);

    // Tap Call button while visible near top
    await tester.tap(find.text('Call').first);
    await tester.pumpAndSettle();

    // 3. Trek Safety Tips groups
    expect(find.text('Trek Safety Tips'), findsOneWidget);
    expect(find.text('Before You Start'), findsOneWidget);
    expect(find.text('Check weather conditions.'), findsOneWidget);
    expect(find.text('During the Trek'), findsOneWidget);
    expect(find.text('Stay on marked trails.'), findsOneWidget);
    expect(find.text('Weather'), findsOneWidget);
    expect(find.text('Avoid exposed areas during thunderstorms.'), findsOneWidget);

    // 4. Important Warnings
    expect(find.text('Important Warnings'), findsOneWidget);
    expect(
      find.text('Weather can change quickly in mountainous areas.'),
      findsOneWidget,
    );
    expect(
      find.text('Do not continue if trail conditions become unsafe.'),
      findsOneWidget,
    );
    expect(
      find.text('Avoid isolated routes when trekking alone.'),
      findsOneWidget,
    );
    expect(find.text('Keep emergency contacts accessible.'), findsOneWidget);

    // 5. Checklist ("Before starting")
    expect(find.text('Before starting'), findsOneWidget);
    expect(find.text('Phone charged'), findsOneWidget);
    expect(find.text('Power bank packed'), findsOneWidget);
    expect(find.text('Water packed'), findsOneWidget);
    expect(find.text('First-aid kit packed'), findsOneWidget);
    expect(find.text('Emergency contact informed'), findsOneWidget);
    expect(find.text('Weather checked'), findsOneWidget);

    // Ensure NO percentage anywhere on screen
    expect(find.textContaining('%'), findsNothing);

    // Toggle checklist checkbox
    final phoneCheckbox = find.byType(Checkbox).first;
    await tester.ensureVisible(phoneCheckbox);
    await tester.pumpAndSettle();
    expect(tester.widget<Checkbox>(phoneCheckbox).value, isFalse);
    await tester.tap(phoneCheckbox);
    await tester.pumpAndSettle();
    expect(tester.widget<Checkbox>(phoneCheckbox).value, isTrue);
  });

  testWidgets('SafetyScreen renders with no overflow at 360dp width and 1.5 text scale',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(360, 800),
            textScaler: TextScaler.linear(1.5),
          ),
          child: SafetyScreen(trek: testTrek),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify all major elements render without overflow exception
    expect(find.text('Safety'), findsOneWidget);
    expect(find.text('Emergency Contacts'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('TrekDetailsScreen has Safety & Emergency card that opens SafetyScreen',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: TrekDetailsScreen(trek: testTrek),
      ),
    );

    // Verify Safety & Emergency card is displayed
    final safetyCardFinder = find.text('Safety & Emergency');
    await tester.ensureVisible(safetyCardFinder);
    await tester.pumpAndSettle();
    expect(safetyCardFinder, findsOneWidget);
    expect(
      find.text('Emergency numbers and trek safety tips'),
      findsOneWidget,
    );

    // Tap the card to navigate
    await tester.tap(safetyCardFinder);
    await tester.pumpAndSettle();

    // Verify on SafetyScreen
    expect(find.text('Safety'), findsOneWidget);
    expect(find.text('For ${testTrek.name}'), findsOneWidget);

    // Verify back button pops back to TrekDetails
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Safety & Emergency'), findsOneWidget);
    expect(find.text('Plan This Trek'), findsOneWidget);
  });
}
