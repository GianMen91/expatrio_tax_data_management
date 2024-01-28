import 'package:coding_challenge/widgets/email_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
void main() {
  group('EmailTextField tests', () {
    testWidgets('UI components are rendered correctly',
            (WidgetTester tester) async {
          TextEditingController emailController = TextEditingController();
          bool validateEmail = false;

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: EmailTextField(
                  emailController: emailController,
                  validateEmail: validateEmail,
                ),
              ),
            ),
          );

          // Check for the existence of the TextField
          expect(find.byKey(const Key('email')), findsOneWidget);
        });

    testWidgets('Email validation error message is displayed',
            (WidgetTester tester) async {
          TextEditingController emailController = TextEditingController();
          bool validateEmail = true; // Set to true to simulate a validation error

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: EmailTextField(
                  emailController: emailController,
                  validateEmail: validateEmail,
                ),
              ),
            ),
          );

          // Check if the error message is displayed
          expect(find.text('Email Can\'t Be Empty'), findsOneWidget);
        });
  });
}