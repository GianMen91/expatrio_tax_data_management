import 'package:coding_challenge/models/tax_residence.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TaxResidence tests', () {
    test('Two identical instances should be equal', () {
      final taxResidence1 = TaxResidence(country: 'USA', id: '123');
      final taxResidence2 = TaxResidence(country: 'USA', id: '123');

      expect(taxResidence1, equals(taxResidence2));
    });

    test('Instances with different properties should not be equal', () {
      final taxResidence1 = TaxResidence(country: 'USA', id: '123');
      final taxResidence2 = TaxResidence(country: 'Canada', id: '456');

      expect(taxResidence1, isNot(equals(taxResidence2)));
    });

    test('Changing a property should not affect equality', () {
      final taxResidence1 = TaxResidence(country: 'USA', id: '123');
      final taxResidence2 = TaxResidence(country: 'USA', id: '123');

      taxResidence2.country = 'Canada';

      expect(taxResidence1, equals(taxResidence2));
    });

    test('toString should return a meaningful representation', () {
      final taxResidence = TaxResidence(country: 'USA', id: '123');

      expect(
        taxResidence.toString(),
        equals('TaxResidence{country: USA, id: 123}'),
      );
    });
  });
}
