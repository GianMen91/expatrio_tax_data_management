import 'package:coding_challenge/widgets/help_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:url_launcher/url_launcher.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  group('HelpButton tests', () {
    late HelpButton helpButton;
    late MockBuildContext mockBuildContext;

    setUp(() {
      mockBuildContext = MockBuildContext();
      helpButton = HelpButton(size: Size(800, 600));
    });

    testWidgets('UI components are rendered correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: helpButton));

      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byIcon(CupertinoIcons.question_circle), findsOneWidget);
      expect(find.text('Help'), findsOneWidget);
    });

    testWidgets('Button press opens external URL', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: helpButton));

      // Mock the launchUrl function from url_launcher package
      launchUrl = (Uri uri) async => true;

      // Tap the help button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verify that the launchUrl function is called with the correct URL
      verify(launchUrl(Uri.parse('https://help.expatrio.com/hc/en-us'))).called(1);
    });

  });
}
