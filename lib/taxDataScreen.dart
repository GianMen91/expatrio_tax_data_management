import 'dart:convert';

import 'package:coding_challenge/models/taxResidence.dart';
import 'package:coding_challenge/taxFormWidget.dart';
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
                    onPressed: () async {
                      if (context.mounted) {
                        try {
                          // Show loading indicator
                          showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          );

                          // Fetch tax data and response
                          Map<String, dynamic> result =
                              await getTaxData(context);

                          // Close the loading indicator
                          //Navigator.pop(context);

                          // Check response status code
                          if (result['response'] != null &&
                              result['response'].statusCode == 200 &&
                              result['taxResidences'] != null) {
                            // Show TaxFormWidget
                            if (context.mounted) {
                              showModalBottomSheet<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  List<TaxResidence> taxResidences =
                                      result['taxResidences'];
                                  return TaxFormWidget(taxResidences);
                                },
                              );
                            } else {
                              // Handle non-200 status code or null tax data
                              // You might want to show an appropriate message
                              print('Failed to load tax data');
                            }
                          }
                        } catch (e) {
                          // Handle error, e.g., show an error message
                          print('Error: $e');
                        }
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

  Future<Map<String, dynamic>> getTaxData(BuildContext context) async {
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

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);

        List<TaxResidence> taxResidences = [];

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

        // Return both raw response and parsed tax data
        return {'response': response, 'taxResidences': taxResidences};
      } else {
        // Return both raw response and null tax data for non-200 status code
        return {'response': response, 'taxResidences': null};
      }
    } catch (e) {
      // Return null tax data for errors
      return {'response': null, 'taxResidences': null};
    }
  }
}
