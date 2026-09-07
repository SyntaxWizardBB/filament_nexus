import 'package:filament_nexus/features/wiki/presentation/widgets/wiki_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('WikiList renders cards without throwing', (tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: WikiList())));
    await tester.pumpAndSettle();

    expect(find.text('Stringing'), findsOneWidget);
    expect(find.byType(Card), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tapping a card opens the detail dialog', (tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: WikiList())));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Stringing'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Schliessen'), findsOneWidget);
  });
}
