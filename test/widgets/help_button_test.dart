import 'package:coding_challenge/widgets/help_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  group('HelpButton tests', () {
    late HelpButton helpButton;

    setUp(() {
      helpButton = HelpButton(size: Size(800, 600));
    });

    testWidgets('UI components are rendered correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: helpButton));

      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byIcon(CupertinoIcons.question_circle), findsOneWidget);
      expect(find.text('Help'), findsOneWidget);
    });

  });
}
