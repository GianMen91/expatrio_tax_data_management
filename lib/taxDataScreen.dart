import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import '../shared/constants.dart';
import 'package:http/http.dart' as http;

class TaxDataScreen extends StatefulWidget {
  const TaxDataScreen(
      {super.key, required this.customerID, required this.accessToken});

  final String accessToken;
  final int customerID;

  @override
  State<TaxDataScreen> createState() => _TaxDataScreenState();
}

class _TaxDataScreenState extends State<TaxDataScreen> {
  @override
  Widget build(BuildContext context) {
    // Get the size of the current screen
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        key: const Key('app_bar'),
        backgroundColor: Colors.white,
        leading: IconButton(
          key: const Key('arrow_back_icon'),
          icon:
              Icon(Icons.arrow_back_rounded, size: size.width > 600 ? 38 : 25),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/CryingGirl.svg",
                    width: size.width > 600 ? 600.0 : 150.0,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Uh-Oh!",
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "We need your tax data in order for you to access your account ",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: themeColor),
                    child: const Text('UPDATE YOUR TAX DATA'),
                    onPressed: () {
                      showTaxForm(context);
                    },
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
            // Align section for displaying developer information
          ],
        ),
      ),
    );
  }

  Future<void> showTaxForm(BuildContext context) async {
    const String baseUrl = 'https://dev-api.expatrio.com';
    int customerId = widget.customerID;

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/v3/customers/$customerId/tax-data"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': widget.accessToken,
        },
      );

      final body = json.decode(response.body);
      if (response.statusCode == 200) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
        }
      } else {
        //
      }
    } on SocketException {
      //
    }

    /*return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return TaxFormWidget(country, taxID);
      },
    );*/
  }
}
