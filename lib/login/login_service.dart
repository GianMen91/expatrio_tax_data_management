import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../shared/constants.dart';
import '../tax_data_screen.dart';

class LoginService {
  static const String baseUrl = 'https://dev-api.expatrio.com';

  Future<bool> login(
      String email, String password, BuildContext context) async {
    final Size size = MediaQuery.of(context).size;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Trying to login...",
            style: TextStyle(
              fontSize: size.width > 600 ? 20.0 : 14.0,
            ))));

    try {
      final data = {"email": email, "password": password};
      final response = await http.post(
        Uri.parse("$baseUrl/auth/login"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      final body = json.decode(response.body);
      if (response.statusCode == 200) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          _showBottomSheet(context, "Successful Login",
              "You will be redirected to your dashboard", true, body);
        }
        return true;
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          _showBottomSheet(
              context, "Invalid Credentials", body['message'], false, body);
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
            null);
      }
      return false;
    }
  }

  void _showBottomSheet(BuildContext context, String title, String message,
      bool isSuccessfulAccess, body) {
    showModalBottomSheet<void>(
      context: context,
      constraints: const BoxConstraints(
        minWidth: double.infinity,
      ),
      builder: (BuildContext context) {
        final Size size = MediaQuery.of(context).size;
        return SizedBox(
          height: size.height / 2,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  isSuccessfulAccess ? Icons.check_circle : Icons.error,
                  color: isSuccessfulAccess ? themeColor : errorMessageColor,
                  size: size.width > 600 ? 90 : 70,
                ),
                SizedBox(height: size.width > 600 ? 35 : 15),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: size.width > 600 ? 30 : 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: size.width > 600 ? 30 : 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(message,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: size.width > 600 ? 22 : 14.0)),
                ),
                SizedBox(height: size.width > 600 ? 35 : 15),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(size.width > 600 ? 168.0 : 48.0,
                            size.width > 600 ? 68.0 : 48.0),
                        backgroundColor: themeColor),
                    child: Text('GOT IT',
                        style:
                            TextStyle(fontSize: size.width > 600 ? 22 : 14.0)),
                    onPressed: () {
                      if (isSuccessfulAccess) {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TaxDataScreen(
                                      accessToken: body['accessToken'],
                                      customerID: body['userId'],
                                    )));
                      } else {
                        Navigator.pop(context);
                      }
                    }),
                const SizedBox(height: 15),
              ],
            ),
          ),
        );
      },
    );
  }
}
