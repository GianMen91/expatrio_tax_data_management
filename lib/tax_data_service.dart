import 'dart:convert';
import 'dart:io';

import 'package:coding_challenge/models/tax_residence.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class TaxDataService {
  static const String _baseUrl = 'https://dev-api.expatrio.com';

  static Future<List<TaxResidence>> getTaxData(
    int customerId,
    String accessToken,
  ) async {
    List<TaxResidence> taxResidences = [];

    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/v3/customers/$customerId/tax-data"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': accessToken,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);

        // Handle primary tax residence separately
        taxResidences.add(
          TaxResidence(
            country: jsonData["primaryTaxResidence"]["country"],
            id: jsonData["primaryTaxResidence"]["id"],
          ),
        );

        // Handle other tax residences
        for (String key in jsonData.keys) {
          if (key.contains("TaxResidence") && jsonData[key] is List<dynamic>) {
            List<dynamic> innerList = jsonData[key];
            for (var innerMap in innerList) {
              taxResidences.add(
                TaxResidence(
                  country: innerMap["country"],
                  id: innerMap["id"],
                ),
              );
            }
          }
        }

        return taxResidences;
      } else {
        // Handle non-200 status codes or other errors
        return taxResidences;
      }
    } on Exception catch (e) {
      // Handle exceptions
      if (kDebugMode) {
        print(e);
      }
      return taxResidences;
    }
  }

  static Future<void> handleSaving(
    int customerId,
    String accessToken,
    List<TaxResidence> taxResidences,
  ) async {
    try {
      int id = customerId;

      List<Map<String, dynamic>> secondaryTaxResidences = [];
      for (int i = 1; i < taxResidences.length; i++) {
        secondaryTaxResidences.add({
          "country": taxResidences[i].country,
          "id": taxResidences[i].id,
        });
      }

      var bodyContent = {
        "primaryTaxResidence": {
          "country": taxResidences.isNotEmpty ? taxResidences[0].country : "",
          "id": taxResidences.isNotEmpty ? taxResidences[0].id : "",
        },
        "usPerson": false,
        "usTaxId": null,
        "secondaryTaxResidence": secondaryTaxResidences,
        "w9FileId": null,
      };
      final response = await http.put(
        Uri.parse("$_baseUrl/v3/customers/$id/tax-data"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': accessToken,
        },
        body: jsonEncode(bodyContent),
      );

      if (response.statusCode == 200) {
        await saveTaxDataLocally(
          {
            "primaryTaxResidence": {
              "country":
                  taxResidences.isNotEmpty ? taxResidences[0].country : "",
              "id": taxResidences.isNotEmpty ? taxResidences[0].id : "",
            },
            "secondaryTaxResidence": secondaryTaxResidences,
          },
          customerId,
        );
      } else {
        // Handle other status codes
      }
    } on SocketException {
      // Handle SocketException
    }
  }

  static Future<void> saveTaxDataLocally(
    Map<String, dynamic> taxData,
    customerId,
  ) async {
    const storage = FlutterSecureStorage();
    await storage.write(
      key: "user_${customerId}_tax_data",
      value: jsonEncode(taxData),
    );
  }
}
