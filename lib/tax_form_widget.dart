import 'dart:convert';
import 'dart:io';

import 'package:coding_challenge/search_box.dart';
import 'package:coding_challenge/shared/countries_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shakemywidget/flutter_shakemywidget.dart';
import '../shared/constants.dart';
import 'package:coding_challenge/models/tax_residence.dart';

import 'package:http/http.dart' as http;

class TaxFormWidget extends StatefulWidget {
  final List<TaxResidence> taxResidences;
  final String accessToken;
  final int customerID;

  const TaxFormWidget(this.taxResidences, this.accessToken, this.customerID,
      {Key? key})
      : super(key: key);

  @override
  State<TaxFormWidget> createState() => _TaxFormWidgetState();
}

class _TaxFormWidgetState extends State<TaxFormWidget> {
  List<TextEditingController> countryControllers = [];
  List<TextEditingController> taxIdControllers = [];
  var _checked = false;
  var savingAttemptedFailed = false;
  final shakeKey = GlobalKey<ShakeWidgetState>();

  List<Map<String, dynamic>> filteredCountries = [];

  String _searchedValue = "";

  final List<bool> _validateTaxIdentificationNumber = [];
  final List<bool> _validateCountry = [];

  static const String baseUrl = 'https://dev-api.expatrio.com';

  // Filter countries based on the searched value

  @override
  void initState() {
    super.initState();
    // Initialize controllers based on the length of the taxResidences list
    for (int i = 0; i < widget.taxResidences.length; i++) {
      countryControllers.add(TextEditingController(
        text: widget.taxResidences[i].country,
      ));
      taxIdControllers.add(TextEditingController(
        text: widget.taxResidences[i].id,
      ));

      _validateTaxIdentificationNumber.add(false);
      _validateCountry.add(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    filteredCountries = CountriesConstants.nationality
        .where((country) => country['label']
            .toString()
            .toLowerCase()
            .contains(_searchedValue.toLowerCase()))
        .toList();

    for (int i = 0; i < widget.taxResidences.length; i++) {
      filteredCountries.removeWhere(
          (item) => item['code'] == widget.taxResidences[i].country);
    }

    return SizedBox(
      height: 600,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 40),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Declaration of financial information",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            buildTaxResidenceFields(0),
            for (int i = 1; i < widget.taxResidences.length; i++)
              buildTaxResidenceFields(i),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    // Add a new tax residence field
                    TaxResidence newTaxResidence =
                        TaxResidence(country: "", id: "");
                    widget.taxResidences.add(newTaxResidence);

                    // Initialize controllers for the new element
                    countryControllers.add(
                        TextEditingController(text: newTaxResidence.country));
                    taxIdControllers
                        .add(TextEditingController(text: newTaxResidence.id));

                    _validateTaxIdentificationNumber.add(false);
                    _validateCountry.add(false);
                  });
                },
                child: const Text("+ ADD ANOTHER",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: themeColor,
                    )),
              ),
            ),
            const SizedBox(height: 20),
            ShakeMe(
              // pass the GlobalKey as an argument
              key: shakeKey,
              shakeOffset: 10,
              shakeDuration: const Duration(milliseconds: 500),
              // Add the child widget that will be animated
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Checkbox(
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.resolveWith((states) {
                        if (!states.contains(MaterialState.selected)) {
                          return Colors.transparent;
                        }
                        return themeColor;
                      }),
                      side: BorderSide(
                          color:
                              !savingAttemptedFailed ? themeColor : Colors.red,
                          width: 2),
                      value: _checked,
                      onChanged: (bool? value) {
                        setState(() {
                          _checked = value!;
                        });
                      },
                    ),
                    const Expanded(
                      child: Text(
                        "I confirm above tax residency and US self-declaration is true and accurate",
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: themeColor),
                  child: const Text(
                    'SAVE',
                    key: Key('save'),
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  onPressed: () async {
                    if (!_checked) {
                      shakeKey.currentState?.shake();
                      setState(() {
                        savingAttemptedFailed = true;
                      });
                    }
                    setState(() {
                      for (int i = 0; i < taxIdControllers.length; i++) {
                        taxIdControllers[i].text.isEmpty
                            ? _validateTaxIdentificationNumber[i] = true
                            : _validateTaxIdentificationNumber[i] = false;
                      }
                      for (int i = 0; i < countryControllers.length; i++) {
                        countryControllers[i].text.isEmpty
                            ? _validateCountry[i] = true
                            : _validateCountry[i] = false;
                      }
                    });

                    // Check if any validation failed
                    if (_validateTaxIdentificationNumber.contains(true) ||
                        _validateCountry.contains(true) ||
                        !_checked) {
                      return; // Stop execution if validation fails
                    }

                    try {
                      int id = widget.customerID;

                      // Construct the dynamic part of the JSON based on taxResidences
                      List<Map<String, dynamic>> secondaryTaxResidences = [];
                      for (int i = 1; i < widget.taxResidences.length; i++) {
                        secondaryTaxResidences.add({
                          "country": widget.taxResidences[i].country,
                          "id": widget.taxResidences[i].id,
                        });
                      }

                      final response = await http.put(
                        Uri.parse("$baseUrl/v3/customers/$id/tax-data"),
                        headers: {
                          'Content-Type': 'application/json',
                          'Authorization': widget.accessToken,
                        },
                        body: jsonEncode({
                          "primaryTaxResidence": {
                            "country": widget.taxResidences.isNotEmpty
                                ? widget.taxResidences[0].country
                                : "",
                            // Handle the case when taxResidences is empty
                            "id": widget.taxResidences.isNotEmpty
                                ? widget.taxResidences[0].id
                                : "",
                            // Handle the case when taxResidences is empty
                          },
                          "usPerson": false,
                          "usTaxId": null,
                          "secondaryTaxResidence": secondaryTaxResidences,
                          "w9FileId": null,
                        }),
                      );

                      if (response.statusCode == 200) {
                        // Handle success
                        print('Success');
                      } else {
                        // Handle other status codes
                        print('Error: ${response.statusCode}');
                      }
                    } on SocketException {
                      // Handle SocketException
                      print('SocketException occurred');
                    }

                    Navigator.pop(context);
                  }),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget buildTaxResidenceFields(int index) {
    String? selectedCountryCode = countryControllers[index].text;

    String? selectedCountryLabel = CountriesConstants.nationality.firstWhere(
      (country) => country['code'] == selectedCountryCode,
      orElse: () => {'label': ''},
    )['label'] as String?;

    void updateSelectedCountry(String? value) {
      setState(() {
        selectedCountryCode = value;
        countryControllers[index].text = value ?? '';
        widget.taxResidences[index].country = value ?? '';
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            index == 0
                ? "Which country serves as your primary tax residence?*"
                    .toUpperCase()
                : "Do you have other tax residences?".toUpperCase(),
            style: const TextStyle(fontSize: 10),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _searchedValue = "";
                filteredCountries = filterCountries(_searchedValue);
              });
              showModalBottomSheet(
                context: context,
                isScrollControlled: false,
                backgroundColor: Colors.transparent,
                builder: (BuildContext context) => StatefulBuilder(
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
                            color: themeColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // Center alignment
                              children: [
                                Text(
                                  "Country",
                                  style: TextStyle(
                                    fontSize: 17,
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
                            filteredCountries = filterCountries(_searchedValue);
                          });
                        }),
                        Expanded(
                          child: filteredCountries.isNotEmpty
                              ? ListView.builder(
                                  itemCount: filteredCountries.length,
                                  itemBuilder: (context, index) {
                                    Map<String, dynamic> country =
                                        filteredCountries[index];

                                    return ListTile(
                                      title: Text(country['label'] as String),
                                      onTap: () {
                                        /*setState(() {
                                          filteredCountries = filterCountries(_searchedValue);
                                        });*/
                                        // Call the callback function to update the state
                                        updateSelectedCountry(
                                            country['code'] as String?);
                                        Navigator.pop(
                                            context); // Close the bottom sheet
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
                ),
              );
            },
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                border: Border.all(
                    color: _validateCountry[index] ? Colors.red : Colors.black),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Row(
                children: [
                  Text(
                    selectedCountryLabel ?? 'Select Country',
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_drop_down, color: Colors.black),
                ],
              ),
            ),
          ),
        ),
        if (_validateCountry[index])
          const Padding(
            padding: EdgeInsets.only(left: 30, top: 8),
            child: Text(
              "Please choose a country",
              style: TextStyle(fontSize: 12, color: Colors.red),
            ),
          ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text("Tax identification number*".toUpperCase(),
              style: const TextStyle(fontSize: 10)),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            key: Key('taxIdentificationNumber$index'),
            controller: taxIdControllers[index],
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (value) {
              setState(() {
                _validateTaxIdentificationNumber[index] = value.isEmpty;
                widget.taxResidences[index].id = value;
              });
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: themeColor),
              ),
              border: const OutlineInputBorder(),
              labelStyle: const TextStyle(
                color: themeColor,
              ),
              errorText: _validateTaxIdentificationNumber[index]
                  ? 'Field is required'
                  : null,
            ),
          ),
        ),
        const SizedBox(height: 10),
        if (index != 0)
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    widget.taxResidences.removeAt(index);
                    countryControllers.removeAt(index);
                    taxIdControllers.removeAt(index);
                    _validateTaxIdentificationNumber.removeAt(index);
                  });
                },
                child: const Text("- REMOVE",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    )),
              ),
            ),
          ),
        const SizedBox(height: 20),
      ],
    );
  }

  List<Map<String, dynamic>> filterCountries(String searchValue) {
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
