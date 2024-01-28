import 'package:coding_challenge/models/item_dropdown.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ItemDropDown tests', () {
    test('Two identical instances should be equal', () {
      const item1 = ItemDropDown('1', 'value1', 'text1');
      const item2 = ItemDropDown('1', 'value1', 'text1');

      expect(item1, equals(item2));
    });

    test('hashCode should be the same for identical instances', () {
      const item1 = ItemDropDown('1', 'value1', 'text1');
      const item2 = ItemDropDown('1', 'value1', 'text1');

      expect(item1.hashCode, equals(item2.hashCode));
    });

    test('toString should return a meaningful representation', () {
      const item = ItemDropDown('1', 'value1', 'text1');

      expect(
        item.toString(),
        equals('ItemDropDown{key: 1, value: value1, text: text1}'),
      );
    });

    test('Instances with different properties should not be equal', () {
      const item1 = ItemDropDown('1', 'value1', 'text1');
      const item2 = ItemDropDown('2', 'value2', 'text2');

      expect(item1, isNot(equals(item2)));
    });
  });
}
