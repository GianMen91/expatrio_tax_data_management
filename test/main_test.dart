import 'package:coding_challenge/main.dart';
import 'package:coding_challenge/src/screens/login_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MyApp widget renders correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the LoginScreen is the initial screen.
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
