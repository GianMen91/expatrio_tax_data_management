import 'package:coding_challenge/widgets/country_dropdown.dart';
import 'package:coding_challenge/widgets/search_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  group('CountryDropdown tests', () {
    late CountryDropdown countryDropdown;
    late MockBuildContext mockBuildContext;

    setUp(() {
      mockBuildContext = MockBuildContext();
      countryDropdown = CountryDropdown(
        updateSelectedCountry: (value) {},
        index: 0,
        validateCountry: [false],
        taxResidences: [],
        selectedCountryLabel: 'Select Country',
      );
    });

    testWidgets('UI components are rendered correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: countryDropdown));

      expect(find.text('Select Country'), findsOneWidget);
      expect(find.byType(SearchBox), findsOneWidget);
      expect(find.byType(ListTile), findsNothing); // List of countries is initially empty
    });

    testWidgets('Tap opens bottom sheet for country selection', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: countryDropdown));

      // Tap the container to open the bottom sheet
      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();

      expect(find.text('Country'), findsOneWidget);
      expect(find.byType(SearchBox), findsOneWidget);
      expect(find.byType(ListTile), findsNothing); // List of countries is initially empty
    });

  });
}
