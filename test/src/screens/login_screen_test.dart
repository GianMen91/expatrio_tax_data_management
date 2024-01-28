import 'package:coding_challenge/screens/login_screen.dart';
import 'package:coding_challenge/services/login_service.dart';
import 'package:coding_challenge/src/screens/login_screen.dart';
import 'package:coding_challenge/widgets/email_text_field.dart';
import 'package:coding_challenge/widgets/help_button.dart';
import 'package:coding_challenge/widgets/password_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockLoginService extends Mock implements LoginService {}

void main() {
  group('LoginScreen tests', () {
    late LoginScreen loginScreen;
    late MockLoginService mockLoginService;

    setUp(() {
      loginScreen = LoginScreen();
      mockLoginService = MockLoginService();
    });

    testWidgets('UI components are rendered correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: loginScreen));

      expect(find.text('EMAIL ADDRESS'), findsOneWidget);
      expect(find.text('PASSWORD'), findsOneWidget);
      expect(find.text('LOGIN'), findsOneWidget);
      expect(find.text("Developed by Giancarlo Mennillo"), findsOneWidget);
      expect(find.byType(HelpButton), findsOneWidget);
      expect(find.byType(EmailTextField), findsOneWidget);
      expect(find.byType(PasswordTextField), findsOneWidget);
    });

    testWidgets('Login button triggers login service', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: loginScreen));

      // Mock the login service
      when(mockLoginService.login(any, any, any)).thenAnswer((_) async => true);

      // Tap the login button
      await tester.tap(find.byKey(Key('login')));
      await tester.pump();

      // Verify that the login service was called
      verify(mockLoginService.login(any, any, any)).called(1);
    });

  });
}
