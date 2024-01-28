import 'package:coding_challenge/main.dart';
import 'package:coding_challenge/src/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
void main() {
  testWidgets('MyApp widget renders correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app title is present on the screen.
    expect(find.text('Expatrio Code Challenge'), findsOneWidget);

    // Verify that the LoginScreen is the initial screen.
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  test('createMaterialColor creates MaterialColor with swatch', () {
    const testColor = Color(0xFF123456);
    final materialColor = createMaterialColor(testColor);

    // Verify that the MaterialColor has the correct values.
    expect(materialColor, isA<MaterialColor>());
    expect(materialColor.shade50, const Color(0xFFA3BAD1));
    expect(materialColor.shade100, const Color(0xFF8AA7C4));
    expect(materialColor.shade200, const Color(0xFF7194B7));
    expect(materialColor.shade300, const Color(0xFF5881AA));
    expect(materialColor.shade400, const Color(0xFF3F6E9D));
    expect(materialColor.shade500, const Color(0xFF265B90));
    expect(materialColor.shade600, const Color(0xFF1E4E80));
    expect(materialColor.shade700, const Color(0xFF174172));
    expect(materialColor.shade800, const Color(0xFF0F345F));
    expect(materialColor.shade900, const Color(0xFF08274C));
  });
}
