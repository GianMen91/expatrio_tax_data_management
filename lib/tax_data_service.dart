import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class TaxDataService {
  static const String _baseUrl = 'https://dev-api.expatrio.com';

  static Future<void> handleSaving(
      int customerId, String accessToken, taxResidences) async {
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
        await saveTaxDataLocally({
          "primaryTaxResidence": {
            "country": taxResidences.isNotEmpty ? taxResidences[0].country : "",
            "id": taxResidences.isNotEmpty ? taxResidences[0].id : "",
          },
          "secondaryTaxResidence": secondaryTaxResidences,
        }, customerId);
      } else {
        // Handle other status codes
      }
    } on SocketException {
      // Handle SocketException
    }
  }

  static Future<void> saveTaxDataLocally(
      Map<String, dynamic> taxData, customerId) async {
    const storage = FlutterSecureStorage();
    await storage.write(
      key: "user_${customerId}_tax_data",
      value: jsonEncode(taxData),
    );
  }
}
