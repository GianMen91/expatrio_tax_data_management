import 'package:coding_challenge/widgets/email_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EmailTextField tests', () {
    late EmailTextField emailTextField;
    late TextEditingController emailController;

    setUp(() {
      emailController = TextEditingController();
      emailTextField = EmailTextField(
        emailController: emailController,
        validateEmail: false,
      );
    });

    testWidgets('UI components are rendered correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: emailTextField));

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('Email validation error message is displayed', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: emailTextField));

      // Trigger validation error
      emailTextField = EmailTextField(
        emailController: emailController,
        validateEmail: true,
      );

      await tester.pumpWidget(MaterialApp(home: emailTextField));

      // Verify that the error message is displayed
      expect(find.text('Email Can\'t Be Empty'), findsOneWidget);
    });

  });
}
