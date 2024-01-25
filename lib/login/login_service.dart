import 'dart:io';

import 'package:coding_challenge/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginService {
  String email = "tito+bs792@expatrio.com";
  String password = "nemampojma";
  String userBaseUrl = 'https://dev-api.expatrio.com';

  Future<bool> login(
      String email, String password, BuildContext context) async {
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Trying to login...")));
    }
    try {
      final data = {"email": email, "password": password};
      var response = await http.post(
        Uri.parse("$userBaseUrl/auth/login"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        if (context.mounted) {
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
                      const Icon(Icons.check_circle,
                          color: themeColor, size: 70),
                      const SizedBox(height: 20),
                      const Text('Successful Login',
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 10),
                      const Text('You will be redirect to you dashboard'),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: themeColor),
                        child: const Text('GOT IT'),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              );
            },
          );
        }
        return true;
      } else {
        var body = json.decode(response.body);
        if (context.mounted) {
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
                      const Icon(Icons.error,
                          color: errorMessageColor, size: 70),
                      const SizedBox(height: 15),
                      const Text('Invalid Credentials',
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child:
                            Text(body['message'], textAlign: TextAlign.center),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: themeColor),
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
        return false;
      }
    } on SocketException {
      //"Impossible to communicate with the server. Check your internet connection and retry!")
      return false;
    }
  }
}
