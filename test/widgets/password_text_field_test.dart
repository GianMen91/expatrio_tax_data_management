import 'package:coding_challenge/widgets/password_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PasswordTextField tests', () {
    testWidgets('UI components are rendered correctly',
        (WidgetTester tester) async {
      TextEditingController passwordController = TextEditingController();
      bool validatePassword = false;

      // Build our app and trigger a frame
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordTextField(
              passwordController: passwordController,
              validatePassword: validatePassword,
            ),
          ),
        ),
      );

      // Verify if the password text field is rendered
      expect(find.byKey(const Key('password')), findsOneWidget);

      // Verify if the password visibility toggle icon is rendered
      expect(
        find.byKey(const Key('password_visibility_toggle')),
        findsOneWidget,
      );
    });

    testWidgets('Password visibility toggles correctly',
        (WidgetTester tester) async {
      TextEditingController passwordController = TextEditingController();
      bool validatePassword = false;

      // Build our app and trigger a frame
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordTextField(
              passwordController: passwordController,
              validatePassword: validatePassword,
            ),
          ),
        ),
      );

      // Get the initial obscureText value
      bool initialObscureText = tester
          .widget<TextField>(find.byKey(const Key('password')))
          .obscureText;

      // Tap on the password visibility toggle icon
      await tester.tap(find.byKey(const Key('password_visibility_toggle')));
      await tester.pump();

      // Get the obscureText value after tapping
      bool updatedObscureText = tester
          .widget<TextField>(find.byKey(const Key('password')))
          .obscureText;

      // Verify that the obscureText value has changed after tapping
      expect(updatedObscureText, !initialObscureText);
    });
  });
}
