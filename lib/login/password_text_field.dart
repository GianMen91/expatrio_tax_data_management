import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../shared/constants.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    required TextEditingController passwordController,
    required bool validatePassword,
  })
      : _passwordController = passwordController,
        _validatePassword = validatePassword;

  final TextEditingController _passwordController;
  final bool _validatePassword;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  late bool _isPasswordVisible;

  @override
  void initState() {
    _isPasswordVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        key: const Key('password'),
        obscureText: !_isPasswordVisible,
        controller: widget._passwordController,
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: kThemeColor),
          ),
          border: const OutlineInputBorder(),
          labelStyle: const TextStyle(color: kThemeColor),
          errorText: widget._validatePassword ? 'Password Can\'t Be Empty' : null,
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
              color: kThemeColor,
            ),
            onPressed: () {
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