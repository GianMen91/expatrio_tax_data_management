import 'package:coding_challenge/src/screens/tax_data_screen.dart';
import 'package:coding_challenge/widgets/tax_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TaxDataScreen tests', () {
    testWidgets('UI components are rendered correctly',
        (WidgetTester tester) async {
      String accessToken =
          "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJ4cDppZCI6IjExMzg3NSIsInhwOmxhc3ROYW1lIjoiQmEgQ2JhIEFpb24iLCJ4cDpzdWJqZWN0IjoiQm9ib24gQmEgQ2JhIEFpb24iLCJ4cDpwdiI6MiwiaXNzIjoieC1wYXRyaW8iLCJ4cDplbWFpbCI6InRpdG8rYnM3OTJAZXhwYXRyaW8uY29tIiwieHA6cm9sZSI6IkNVU1RPTUVSIiwieHA6Zmlyc3ROYW1lIjoiQm9ib24iLCJleHAiOjE3MDY0NjI3MDgsImlhdCI6MTcwNjQ1OTEwOCwianRpIjoiMTIzIn0.SvlGqvb3EiJohbb0JLG8Sc4rD1dHxMduIePCVX1rGJ-mv2ug484Re8nnofD-EBUAnUYC1ufbb73et5rBYv9fhQ";
      int customerId = 113875;
      await tester.pumpWidget(MaterialApp(
          home:
              TaxDataScreen(customerId: customerId, accessToken: accessToken)));

      expect(find.byType(AppBar), findsOneWidget);

      var arrowBackIcon = find.byKey(const Key('arrow_back_icon'));
      expect(arrowBackIcon, findsOneWidget);

      expect(find.byType(SvgPicture), findsOneWidget);

      var titleTextField = find.byKey(const Key('title_text_field'));
      expect(titleTextField, findsOneWidget);

      final titleTextFieldWidget = tester.widget<Text>(titleTextField);
      expect(titleTextFieldWidget.data, "Uh-Oh!");

      var descriptionTextField =
          find.byKey(const Key('description_text_field'));
      expect(descriptionTextField, findsOneWidget);

      final descriptionTextFieldtWidget =
          tester.widget<Text>(descriptionTextField);
      expect(descriptionTextFieldtWidget.data,
          "We need your tax data for you to access your account.");

      expect(find.byType(ElevatedButton), findsOneWidget);

      // Verifying the presence and properties of the 'ADD TO ORDER' button
      var updateTaxDataButton = find.byKey(const Key('update_tax_data_button'));
      expect(updateTaxDataButton, findsOneWidget);
      final buttonWidget = tester.widget<ElevatedButton>(updateTaxDataButton);
      expect(
        buttonWidget.child,
        isA<Text>().having(
          (text) => text.data,
          'text.data',
          "UPDATE YOUR TAX DATA",
        ),
      );
    });
  });
}
