import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginService {
  String email = "tito+bs792@expatrio.com";
  String password = "nemampojma";
  String userBaseUrl = 'https://dev-api.expatrio.com';

  Future<bool> login(
      String email, String password, BuildContext context) async {
    setAccountData(email, password);
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Trying to login...")));
    }
    try {
      final data = {
        "email": "tito+bs792@expatrio.com",
        "password": "nemampojma"
      };
      var response = await http.post(
        Uri.parse("$userBaseUrl/auth/login"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        var body = json.decode(response.body);

        return true;
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Invalid credentials")));
        }
        return false;
      }
    } on SocketException {
      //"Impossible to communicate with the server. Check your internet connection and retry!")
      return false;
    }
  }

  void setAccountData(String email, String pass) {
    this.email = email;
    this.password = pass;
  }
}
