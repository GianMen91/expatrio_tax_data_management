import 'package:coding_challenge/widgets/password_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PasswordTextField tests', () {
    late PasswordTextField passwordTextField;
    late TextEditingController mockPasswordController;

    setUp(() {
      mockPasswordController = TextEditingController();
      passwordTextField = PasswordTextField(
        passwordController: mockPasswordController,
        validatePassword: false,
      );
    });

    testWidgets('UI components are rendered correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: passwordTextField));

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('Toggling password visibility works', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: passwordTextField));

      // Initial state - password is not visible
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      // Tap the visibility icon
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pumpAndSettle();

      // Password is now visible
      expect(find.byIcon(Icons.visibility), findsOneWidget);

      // Tap the visibility icon again
      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pumpAndSettle();

      // Password is not visible again
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

  });
}
