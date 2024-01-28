import 'dart:convert';

import 'package:coding_challenge/models/tax_residence.dart';
import 'package:coding_challenge/services/tax_data_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('TaxDataService tests', () {
    late TaxDataService taxDataService;
    late MockHttpClient mockHttpClient;

    setUp(() {
      taxDataService = TaxDataService();
      mockHttpClient = MockHttpClient();
    });

    test('getTaxData returns List<TaxResidence> on success', () async {
      // Mock successful response
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(
        json.encode({
          "primaryTaxResidence": {"country": "USA", "id": "1"},
          "SecondaryTaxResidence": [
            {"country": "Canada", "id": "2"},
            {"country": "Germany", "id": "3"}
          ]
        }),
        200,
      ));

      final taxResidences = await taxDataService.getTaxData(1, 'fakeAccessToken', http.Client());

      expect(taxResidences.length, 3);
      expect(taxResidences[0].country, 'USA');
      expect(taxResidences[1].country, 'Canada');
      expect(taxResidences[2].country, 'Germany');
    });

    test('getTaxData returns empty list on non-200 status code', () async {
      // Mock unsuccessful response
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(json.encode({}), 404));

      final taxResidences = await taxDataService.getTaxData(1, 'fakeAccessToken', mockHttpClient);

      expect(taxResidences.isEmpty, true);
    });

    test('handleSaving saves tax data locally on successful server save', () async {
      // Mock successful response
      when(mockHttpClient.put(any, headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(json.encode({}), 200));

      final taxResidences = [
        TaxResidence(country: 'USA', id: '1'),
        TaxResidence(country: 'Canada', id: '2'),
        TaxResidence(country: 'Germany', id: '3'),
      ];

      await taxDataService.handleSaving(1, 'fakeAccessToken', taxResidences, mockHttpClient);

      // Verify that saveTaxDataLocally was called
      verify(taxDataService.saveTaxDataLocally(any, 1)).called(1);
    });

  });
}
