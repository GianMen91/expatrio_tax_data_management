// Import necessary packages and local dependencies
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../shared/constants_test.dart';
import '../src/screens/tax_data_screen_test.dart';

// A class providing login services
class LoginService {
  // Base URL for API requests
  static const String baseUrl = 'https://dev-api.expatrio.com';

  // Method for handling user login
  Future<bool> login(
      String email, String password, BuildContext context) async {
    final Size size = MediaQuery.of(context).size;

    // Show a snack bar indicating that the login process is ongoing
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Trying to login...",
            style: TextStyle(
              fontSize: size.width > 600 ? 20.0 : 14.0,
            ))));

    try {
      // Prepare login data
      final data = {"email": email, "password": password};

      // Send a POST request to the login API
      final response = await http.post(
        Uri.parse("$baseUrl/auth/login"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      // Decode the response body
      final responseBody = json.decode(response.body);

      // Check the status code of the response
      if (response.statusCode == 200) {
        // If successful, show a success bottom sheet
        if (context.mounted) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          _showSuccessBottomSheet(context, responseBody);
        }
        return true;
      } else {
        // If unsuccessful, show an error bottom sheet
        if (context.mounted) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          _showErrorBottomSheet(context, responseBody['message']);
        }
        return false;
      }
    } on SocketException catch (e) {
      // Handle socket exception (no internet connection)
      if (context.mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        _showErrorBottomSheet(context,
            "Unable to communicate with the server. Check your internet connection and retry! Error: $e");
      }
      return false;
    }
  }

  // Method to show a success bottom sheet
  void _showSuccessBottomSheet(
      BuildContext context, Map<String, dynamic> responseBody) {
    _showBottomSheet(context, "Successful Login",
        "Redirecting to your dashboard", true, responseBody);
  }

  // Method to show an error bottom sheet
  void _showErrorBottomSheet(BuildContext context, String errorMessage) {
    _showBottomSheet(context, "Invalid Credentials", errorMessage, false, null);
  }

  // Method to show a bottom sheet with various messages
  void _showBottomSheet(BuildContext context, String title, String message,
      bool successfulAccess, Map<String, dynamic>? responseBody) {
    showModalBottomSheet<void>(
      context: context,
      constraints: const BoxConstraints(
        minWidth: double.infinity,
      ),
      builder: (BuildContext context) {
        final Size size = MediaQuery.of(context).size;
        return SizedBox(
          height: size.width > 600 ? size.height / 2 : 300,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  successfulAccess ? Icons.check_circle : Icons.error,
                  color: successfulAccess ? kThemeColor : kErrorMessageColor,
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
                // Elevated button for user interaction
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(size.width > 600 ? 168.0 : 48.0,
                        size.width > 600 ? 68.0 : 48.0),
                    backgroundColor: kThemeColor,
                  ),
                  child: Text('GOT IT',
                      style: TextStyle(fontSize: size.width > 600 ? 22 : 14.0)),
                  onPressed: () {
                    // Navigate based on the result of the login attempt
                    if (successfulAccess) {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TaxDataScreen(
                                    accessToken: responseBody!['accessToken'],
                                    customerId: responseBody['userId'],
                                  )));
                    } else {
                      Navigator.pop(context);
                    }
                  },
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
