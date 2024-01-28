import 'package:coding_challenge/search_box.dart';
import 'package:coding_challenge/shared/constants.dart';
import 'package:coding_challenge/shared/countries_constants.dart';
import 'package:flutter/material.dart';

import 'models/tax_residence.dart';

class CountryDropdown extends StatefulWidget {
  CountryDropdown({
    super.key,
    required this.updateSelectedCountry,
    required this.index,
    required this.validateCountry,
    required this.taxResidences,
    required this.selectedCountryLabel,
  });

  final void Function(String? value) updateSelectedCountry;
  final int index;
  final String? selectedCountryLabel;
  List<bool> validateCountry = [];
  final List<TaxResidence> taxResidences;

  @override
  State<CountryDropdown> createState() => _CountryDropdownState();
}

class _CountryDropdownState extends State<CountryDropdown> {
  String _searchedValue = "";
  List<Map<String, dynamic>> _filteredCountries = [];

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    _filteredCountries = _filterCountries(_searchedValue);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _searchedValue = "";
            _filteredCountries = _filterCountries(_searchedValue);
          });
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            constraints: const BoxConstraints(
              minWidth: double.infinity,
            ),
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) =>
                _buildCountrySelectionSheet(size, widget.updateSelectedCountry),
          );
        },
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            border: Border.all(
                color: widget.validateCountry[widget.index]
                    ? Colors.red
                    : Colors.black),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Row(
            children: [
              Text(
                widget.selectedCountryLabel ?? 'Select Country',
              ),
              const Spacer(),
              const Icon(Icons.arrow_drop_down, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountrySelectionSheet(
      Size size, void Function(String? value) updateSelectedCountry) {
    return StatefulBuilder(
      builder: (context, state) => Container(
        constraints: const BoxConstraints(
          maxHeight: 400,
          minWidth: double.infinity,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: Column(
          children: [
            Container(
              // Container for the blue background at the top
              decoration: const BoxDecoration(
                color: kThemeColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // Center alignment
                  children: [
                    Text(
                      "Country",
                      style: TextStyle(
                        fontSize: size.width > 600 ? 22 : 17.0,
                        color: Colors.white,
                        // Text color on blue background
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SearchBox(onChanged: (value) {
              // Update the searched value and refresh the item manager
              state(() {
                _searchedValue = value;
                _filteredCountries = _filterCountries(_searchedValue);
              });
            }),
            Expanded(
              child: _filteredCountries.isNotEmpty
                  ? ListView.builder(
                      itemCount: _filteredCountries.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> country =
                            _filteredCountries[index];

                        return ListTile(
                          title: Text(country['label'] as String),
                          onTap: () {
                            /*setState(() {
                                      filteredCountries = filterCountries(_searchedValue);
                                    });*/
                            // Call the callback function to update the state
                            updateSelectedCountry(country['code'] as String?);
                            Navigator.pop(context); // Close the bottom sheet
                          },
                        );
                      },
                    )
                  : const Center(
                      child: Text("No data found"),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _filterCountries(String searchValue) {
    var listOfCountries = CountriesConstants.nationality
        .where((country) => country['label']
            .toString()
            .toLowerCase()
            .contains(searchValue.toLowerCase()))
        .toList();

    for (int i = 0; i < widget.taxResidences.length; i++) {
      listOfCountries.removeWhere(
          (item) => item['code'] == widget.taxResidences[i].country);
    }
    return listOfCountries;
  }
}
