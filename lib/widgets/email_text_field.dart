// Import necessary packages and libraries
import 'package:flutter/material.dart';

// Import local dependencies
import '../shared/constants.dart';

// A custom widget representing an email text field
class EmailTextField extends StatelessWidget {
  // Constructor for the EmailTextField widget
  const EmailTextField({
    super.key,
    required TextEditingController emailController,
    required bool validateEmail,
  })  : _emailController = emailController,
        _validateEmail = validateEmail;

  // Controller for the email text field
  final TextEditingController _emailController;

  // Flag to validate email
  final bool _validateEmail;

  // Build method for the widget
  @override
  Widget build(BuildContext context) {
    // Return a padded text field for email input
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        key: const Key('email'), // Unique key for testing the TextField
        controller: _emailController, // Controller for managing text input
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: kThemeColor), // Border color when focused
          ),
          border: const OutlineInputBorder(), // Default border
          labelStyle: const TextStyle(color: kThemeColor), // Label text color
          errorText: _validateEmail
              ? 'Email Can\'t Be Empty'
              : null, // Error text if email is empty
        ),
      ),
    );
  }
}
