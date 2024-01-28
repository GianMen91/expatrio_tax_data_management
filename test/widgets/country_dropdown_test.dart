import 'package:coding_challenge/widgets/search_box.dart';
import 'package:coding_challenge/shared/constants.dart';
import 'package:coding_challenge/shared/countries_constants.dart';
import 'package:flutter/material.dart';

import '../models/tax_residence_test.dart';

class CountryDropdown extends StatefulWidget {
  const CountryDropdown({
    Key? key,
    required this.updateSelectedCountry,
    required this.index,
    required this.validateCountry,
    required this.taxResidences,
    required this.selectedCountryLabel,
  }) : super(key: key);

  final void Function(String? value) updateSelectedCountry;
  final int index;
  final String? selectedCountryLabel;
  final List<bool> validateCountry;
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
                _buildCountrySelectionSheet(size),
          );
        },
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.validateCountry[widget.index] ? Colors.red : Colors.black,
            ),
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

  // Builds the bottom sheet for country selection
  Widget _buildCountrySelectionSheet(Size size) {
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
            // Container at the top with "Country" text
            _buildTopContainer(size),
            // Search box to filter countries
            SearchBox(onChanged: (value) {
              state(() {
                _searchedValue = value;
                _filteredCountries = _filterCountries(_searchedValue);
              });
            }),
            // List of countries to choose from
            Expanded(
              child: _filteredCountries.isNotEmpty
                  ? ListView.builder(
                itemCount: _filteredCountries.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> country = _filteredCountries[index];

                  return ListTile(
                    title: Text(country['label'] as String),
                    onTap: () {
                      widget.updateSelectedCountry(country['code'] as String?);
                      Navigator.pop(context);
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

  // Container at the top of the bottom sheet
  Container _buildTopContainer(Size size) {
    return Container(
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
          children: [
            Text(
              "Country",
              style: TextStyle(
                fontSize: size.width > 600 ? 22 : 17.0,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Filters the list of countries based on the search value
  List<Map<String, dynamic>> _filterCountries(String searchValue) {
    var listOfCountries = CountriesConstants.nationality
        .where((country) => country['label']
        .toString()
        .toLowerCase()
        .contains(searchValue.toLowerCase()))
        .toList();

    // Remove countries that are already selected as tax residences
    for (int i = 0; i < widget.taxResidences.length; i++) {
      listOfCountries.removeWhere(
            (item) => item['code'] == widget.taxResidences[i].country,
      );
    }
    return listOfCountries;
  }
}
