import 'package:coding_challenge/models/tax_residence.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TaxResidence', () {
    test('Constructor should initialize properties correctly', () {
      // Arrange
      const String country = 'AF';
      const String id = '1234';

      final TaxResidence taxResidence = TaxResidence(country: country, id: id);

      expect(taxResidence.country, equals(country));
      expect(taxResidence.id, equals(id));
    });
  });
}
