import 'package:coding_challenge/src/screens/login_screen.dart';
import 'package:coding_challenge/widgets/email_text_field.dart';
import 'package:coding_challenge/widgets/help_button.dart';
import 'package:coding_challenge/widgets/password_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginScreen tests', () {
    testWidgets('UI components are rendered correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      var itemImage = find.byKey(const Key('expatrio_logo'));
      expect(itemImage, findsOneWidget);

      var emailTextField = find.byKey(const Key('email_text_field'));
      expect(emailTextField, findsOneWidget);

      var passwordTextField = find.byKey(const Key('password_text_field'));
      expect(passwordTextField, findsOneWidget);

      var developerInfoText = find.byKey(const Key('developer_info_text'));
      expect(developerInfoText, findsOneWidget);

      final developerInfoTextwidget = tester.widget<Text>(developerInfoText);
      expect(developerInfoTextwidget.data, "Developed by Giancarlo Mennillo");

      expect(find.text("Developed by Giancarlo Mennillo"), findsOneWidget);
      expect(find.byType(HelpButton), findsOneWidget);
      expect(find.byType(EmailTextField), findsOneWidget);
      expect(find.byType(PasswordTextField), findsOneWidget);
    });

    // Test to check if the image path in ItemCard is correct
    testWidgets('Image path is correct', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      // Finding the item image and verifying its presence
      var itemImage = find.byKey(const Key('expatrio_logo'));
      expect(itemImage, findsOneWidget);

      // Extracting image properties and verifying the image path
      final Image image = itemImage.evaluate().single.widget as Image;
      var imagePath = (image.image as AssetImage).assetName;

      expect(image, isInstanceOf<Image>());
      expect(image.image, isInstanceOf<AssetImage>());
      expect(imagePath, "assets/2019_XP_logo_white.png");
    });
  });
}
