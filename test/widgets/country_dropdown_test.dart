import 'package:coding_challenge/models/tax_residence.dart';
import 'package:coding_challenge/widgets/country_dropdown.dart';
import 'package:coding_challenge/widgets/search_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CountryDropdown tests', () {
    CountryDropdown countryDropdown = CountryDropdown(
      updateSelectedCountry: (value) {},
      index: 1,
      validateCountry: const [false, false],
      taxResidences: [
        TaxResidence(country: "AD", id: "12bb"),
        TaxResidence(country: "AL", id: "fffg")
      ],
      selectedCountryLabel: 'Albania',
    );

    testWidgets('UI components are rendered correctly',
            (WidgetTester tester) async {
          await tester.pumpWidget(MaterialApp(home: countryDropdown));

          // Tap the container to open the bottom sheet
          await tester.tap(find.byType(GestureDetector));
          await tester.pumpAndSettle();

          var countryDropdownTitle =
          find.byKey(const Key('country_dropdown_title'));
          expect(countryDropdownTitle, findsOneWidget);

          final countryDropdownTitleWidget =
          tester.widget<Text>(countryDropdownTitle);
          expect(countryDropdownTitleWidget.data, "Country");

          expect(find.byType(SearchBox), findsOneWidget);
          expect(find.byKey(const Key('country_list_view')), findsOneWidget);
        });
  });
}
