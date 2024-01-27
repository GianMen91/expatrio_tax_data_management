import 'dart:convert';

import 'package:coding_challenge/models/tax_residence.dart';
import 'package:coding_challenge/tax_form_widget.dart';
import 'package:flutter/material.dart';
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
                    onPressed: () async {
                      if (context.mounted) {
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return FutureBuilder(
                              future: getTaxData(context),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  // While waiting for the response, show CircularProgressIndicator
                                  return const SizedBox(
                                    height: 600,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                          color: themeColor),
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  // Handle error case
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  // Once you have the response, show TaxFormWidget
                                  return SizedBox(
                                    height: 600,
                                    child: TaxFormWidget(snapshot
                                        .data),
                                  );
                                }
                              },
                            );
                          },
                        );
                      }
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

  Future<List<TaxResidence>> getTaxData(BuildContext context) async {
    const String baseUrl = 'https://dev-api.expatrio.com';
    int customerId = widget.customerID;
    List<TaxResidence> taxResidences = [];

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/v3/customers/$customerId/tax-data"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': widget.accessToken,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);

        // Handle primary tax residence separately
        taxResidences.add(TaxResidence(
          country: jsonData["primaryTaxResidence"]["country"],
          id: jsonData["primaryTaxResidence"]["id"],
        ));

        // Handle other tax residences
        for (String key in jsonData.keys) {
          if (key.contains("TaxResidence") && jsonData[key] is List<dynamic>) {
            List<dynamic> innerList = jsonData[key];
            for (var innerMap in innerList) {
              taxResidences.add(TaxResidence(
                country: innerMap["country"],
                id: innerMap["id"],
              ));
            }
          }
        }

        return taxResidences;
      } else {
        return taxResidences;
      }
    }  on Exception {
      return taxResidences;
    }
  }
}
