import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../shared/constants.dart';

class LoginService {
  static const String userBaseUrl = 'https://dev-api.expatrio.com';

  Future<bool> login(
      String email, String password, BuildContext context) async {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Trying to login...")));

    try {
      final data = {"email": email, "password": password};
      final response = await http.post(
        Uri.parse("$userBaseUrl/auth/login"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      final body = json.decode(response.body);
      if (response.statusCode == 200) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          _showBottomSheet(context, "Successful Login",
              "You will be redirected to your dashboard", true);
        }
        return true;
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          _showBottomSheet(
              context, "Invalid Credentials", body['message'], false);
        }
        return false;
      }
    } on SocketException {
      if (context.mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        _showBottomSheet(
          context,
          "Connection Error",
          "Impossible to communicate with the server. Check your internet connection and retry!",
          false,
        );
      }
      return false;
    }
  }

  void _showBottomSheet(BuildContext context, String title, String message,
      bool isSuccessfulAccess) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  isSuccessfulAccess ? Icons.check_circle : Icons.error,
                  color: isSuccessfulAccess ? themeColor : errorMessageColor,
                  size: 70,
                ),
                const SizedBox(height: 15),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(message, textAlign: TextAlign.center),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: themeColor),
                  child: const Text('GOT IT'),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        );
      },
    );
  }
}
