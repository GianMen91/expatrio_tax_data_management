import 'package:coding_challenge/models/tax_residence.dart';
import 'package:coding_challenge/widgets/tax_form_widget.dart';
import 'package:coding_challenge/widgets/country_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TaxFormWidget tests', () {
    late TaxFormWidget taxFormWidget;
    late List<TaxResidence> mockTaxResidences;
    late String mockAccessToken;
    late int mockCustomerID;

    setUp(() {
      mockTaxResidences = [
        TaxResidence(country: 'USA', id: '123456'),
        TaxResidence(country: 'Germany', id: '789012'),
      ];
      mockAccessToken = 'mockAccessToken';
      mockCustomerID = 123;

      taxFormWidget = TaxFormWidget(mockTaxResidences, mockAccessToken, mockCustomerID);
    });

    testWidgets('UI components are rendered correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: taxFormWidget)));

      expect(find.text("Declaration of financial information"), findsOneWidget);
      expect(find.text("Which country serves as your primary tax residence?*"), findsOneWidget);
      expect(find.text("Tax identification number*"), findsOneWidget);
      expect(find.byType(CountryDropdown), findsNWidgets(2)); // Assuming initial count is 2
      expect(find.byKey(const Key('save')), findsOneWidget);
    });

    testWidgets('Adding another tax residence updates the UI', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: taxFormWidget)));

      // Initial count of tax residences
      final initialCount = mockTaxResidences.length;

      // Tap the "+ ADD ANOTHER" button
      await tester.tap(find.text("+ ADD ANOTHER"));
      await tester.pumpAndSettle();

      // Updated count of tax residences
      final updatedCount = initialCount + 1;

      // Verify that the UI reflects the updated count
      expect(find.byType(CountryDropdown), findsNWidgets(updatedCount));
      expect(find.text("- REMOVE"), findsOneWidget);
    });

  });
}
