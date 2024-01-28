// Import necessary Flutter packages and local dependencies
import 'package:flutter/material.dart';

import '../shared/constants_test.dart';

// Custom widget for the Password Text Field
class PasswordTextField extends StatefulWidget {
  // Constructor to initialize the PasswordTextField
  const PasswordTextField({
    super.key,
    required TextEditingController passwordController,
    required bool validatePassword,
  })  : _passwordController = passwordController,
        _validatePassword = validatePassword;

  // Instance variables
  final TextEditingController _passwordController;
  final bool _validatePassword;

  // Override createState() to create the state for the PasswordTextField
  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

// State class for the PasswordTextField
class _PasswordTextFieldState extends State<PasswordTextField> {
  // Variable to track whether the password is visible or not
  late bool _isPasswordVisible;

  // Initialize the state
  @override
  void initState() {
    _isPasswordVisible = false; // Password is initially not visible
    super.initState();
  }

  // Build method to construct the UI for the PasswordTextField
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        key: const Key('password'),
        // Key for testing purposes
        obscureText: !_isPasswordVisible,
        // Show/hide password based on visibility
        controller: widget._passwordController,
        // Controller for password input
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: kThemeColor),
          ),
          border: const OutlineInputBorder(),
          labelStyle: const TextStyle(color: kThemeColor),
          errorText:
              widget._validatePassword ? 'Password Can\'t Be Empty' : null,
          // Display error message if password is empty
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
              color: kThemeColor,
            ),
            onPressed: () {
              // Toggle the visibility of the password
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
        ),
      ),
    );
  }
}
