import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../shared/constants.dart';

class EmailTextField extends StatelessWidget {
  const EmailTextField({
    super.key,
    required TextEditingController emailController,
    required bool validateEmail,
  })  : _emailController = emailController,
        _validateEmail = validateEmail;

  final TextEditingController _emailController;
  final bool _validateEmail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        key: const Key('email'),
        controller: _emailController,
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: kThemeColor),
          ),
          border: const OutlineInputBorder(),
          labelStyle: const TextStyle(color: kThemeColor),
          errorText: _validateEmail ? 'Email Can\'t Be Empty' : null,
        ),
      ),
    );
  }
}