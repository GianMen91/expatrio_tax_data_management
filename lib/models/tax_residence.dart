// Class representing a TaxResidence item
class TaxResidence {
  // Properties of a TaxResidence item
  String country; // The country associated with the tax residence
  String id; // Identifier for the tax residence

  // Constructor for creating a TaxResidence item
  TaxResidence({
    required this.country, // Country is required for initialization
    required this.id, // ID is required for initialization
  });
}
