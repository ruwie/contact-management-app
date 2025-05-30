import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:contact_management_system/main.dart';

void main() {
  testWidgets('App loads and shows empty contacts text', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(ContactApp());

    // Check if the app bar title 'Contacts' exists
    expect(find.text('Contacts'), findsOneWidget);

    // Check if empty contacts message appears
    expect(find.text('No contacts. Add some!'), findsOneWidget);

    // Check if add floating button exists
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
