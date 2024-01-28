// Import necessary packages and local dependencies
import 'package:coding_challenge/widgets/password_text_field.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../shared/constants.dart';
import '../../widgets/email_text_field.dart';
import '../../widgets/help_button.dart';
import '../../services/login_service.dart';

// A StatefulWidget representing the login screen
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// The corresponding State class for the Login widget
class _LoginScreenState extends State<LoginScreen> {
  // Controllers for email and password input fields
  final TextEditingController _emailController =
      TextEditingController(text: 'tito+bs792@expatrio.com');
  final TextEditingController _passwordController =
      TextEditingController(text: 'nemampojma');

  // Service for handling login functionality
  final LoginService _loginService = LoginService();

  // Flags to validate email and password inputs
  bool _validateEmail = false;
  bool _validatePassword = false;

  // Build method for the widget
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    // Scaffold widget representing the overall structure of the screen
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Positioned widget for the background animation
            Positioned(
              bottom: 0,
              width: size.width,
              child: Opacity(
                opacity: 0.5,
                child: Lottie.asset(
                  'assets/login-background.json',
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
            // SingleChildScrollView to enable scrolling
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: Image.asset('assets/2019_XP_logo_white.png'),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Custom widget for email input field
                  _buildRowWithIconAndText(Icons.mail_outline, 'EMAIL ADDRESS'),
                  const SizedBox(height: 10),
                  EmailTextField(
                      emailController: _emailController,
                      validateEmail: _validateEmail),
                  const SizedBox(height: 10),
                  // Custom widget for password input field
                  _buildRowWithIconAndText(Icons.lock_outline, 'PASSWORD'),
                  const SizedBox(height: 10),
                  PasswordTextField(
                      passwordController: _passwordController,
                      validatePassword: _validatePassword),
                  const SizedBox(height: 20),
                  // Custom widget for the login button
                  _buildSaveButton(context),
                  const Text("Developed by Giancarlo Mennillo",
                      style: TextStyle(fontSize: 10)),
                ],
              ),
            ),
            // Custom widget for the help button
            HelpButton(size: size),
          ],
        ),
      ),
    );
  }

  // Custom widget for the login button
  Widget _buildSaveButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      margin: const EdgeInsets.all(15),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: kThemeColor,
        ),
        child: const Text(
          'LOGIN',
          key: Key('login'),
          style: TextStyle(
            fontSize: 17,
          ),
        ),
        onPressed: () async {
          // Remove whitespaces from the email
          String emailWithoutWhiteSpace =
              _emailController.text.replaceAll(RegExp(r"\s+\b|\b\s"), "");

          // Validate and set flags for email and password
          setState(() {
            _emailController.text.isEmpty
                ? _validateEmail = true
                : _validateEmail = false;
          });
          setState(() {
            _passwordController.text.isEmpty
                ? _validatePassword = true
                : _validatePassword = false;
          });

          // Perform login if inputs are valid
          if (!_validateEmail && !_validatePassword) {
            await _loginService.login(
                emailWithoutWhiteSpace, _passwordController.text, context);
          }
        },
      ),
    );
  }

  // Custom widget for a row containing an icon and text
  Widget _buildRowWithIconAndText(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Icon(icon, size: 15),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}
