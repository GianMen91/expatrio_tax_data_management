import 'package:coding_challenge/models/tax_residence.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:coding_challenge/widgets/tax_form_widget.dart';

void main() {
  TaxFormWidget taxFormWidget = TaxFormWidget(
    taxResidences: [
      TaxResidence(country: "AD", id: "12bb"),
      TaxResidence(country: "AL", id: "fffg")
    ],
    accessToken:
        "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJ4cDppZCI6IjExMzg3NSIsInhwOmxhc3ROYW1lIjoiQmEgQ2JhIEFpb24iLCJ4cDpzdWJqZWN0IjoiQm9ib24gQmEgQ2JhIEFpb24iLCJ4cDpwdiI6MiwiaXNzIjoieC1wYXRyaW8iLCJ4cDplbWFpbCI6InRpdG8rYnM3OTJAZXhwYXRyaW8uY29tIiwieHA6cm9sZSI6IkNVU1RPTUVSIiwieHA6Zmlyc3ROYW1lIjoiQm9ib24iLCJleHAiOjE3MDY0NjI3MDgsImlhdCI6MTcwNjQ1OTEwOCwianRpIjoiMTIzIn0.SvlGqvb3EiJohbb0JLG8Sc4rD1dHxMduIePCVX1rGJ-mv2ug484Re8nnofD-EBUAnUYC1ufbb73et5rBYv9fhQ",
    customerId: 113875,
  );

  testWidgets('TaxFormWidget Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: taxFormWidget),
      ),
    );

    // Verify if the title is displayed
    expect(find.text('Declaration of financial information'), findsOneWidget);

    // Verify if the "Add Another" button is displayed
    expect(find.text('+ ADD ANOTHER'), findsOneWidget);

    // Tap on "Add Another" button
    await tester.tap(find.text('+ ADD ANOTHER'));
    await tester.pump();

    expect(find.text('Do you have other tax residences?'.toUpperCase()),
        findsWidgets);
  });
}
