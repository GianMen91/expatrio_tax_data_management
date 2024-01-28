// A class representing an item in a dropdown list with a key, value, and text.
class ItemDropDown {
  // Constructor to initialize the properties.
  const ItemDropDown(this.key, this.value, this.text);

  // Properties of the class.
  final String key;
  final String value;
  final String text;

  // Override the equality operator for comparing instances.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ItemDropDown &&
              runtimeType == other.runtimeType &&
              key == other.key &&
              value == other.value &&
              text == other.text;

  // Override the hashCode to generate a hash based on properties.
  @override
  int get hashCode => key.hashCode ^ value.hashCode ^ text.hashCode;

  // Override the toString method to provide a string representation of the object.
  @override
  String toString() {
    return 'ItemDropDown{key: $key, value: $value, text: $text}';
  }
}
