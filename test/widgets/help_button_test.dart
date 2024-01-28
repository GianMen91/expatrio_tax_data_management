import 'package:coding_challenge/widgets/help_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HelpButton tests', () {
    testWidgets('UI components are rendered correctly',
        (WidgetTester tester) async {
      // Build our app and trigger a frame
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HelpButton(size: Size(400, 600)),
          ),
        ),
      );

      // Verify if the help button is rendered
      expect(find.byKey(const Key('help_button')), findsOneWidget);

      // Verify if the help icon is rendered
      expect(find.byKey(const Key('help_icon')), findsOneWidget);

      // Verify if the help text is rendered
      var helpText = find.byKey(const Key('help_text'));
      expect(helpText, findsOneWidget);

      final helpTextWidget = tester.widget<Text>(helpText);
      expect(helpTextWidget.data, "Help");
    });
  });
}
