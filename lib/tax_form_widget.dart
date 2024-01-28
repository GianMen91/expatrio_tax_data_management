import 'dart:convert';
import 'dart:io';

import 'package:coding_challenge/search_box.dart';
import 'package:coding_challenge/shared/countries_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  final List<TextEditingController> _countryControllers = [];
  final List<TextEditingController> _taxIdControllers = [];
  final List<bool> _validateTaxIdentificationNumber = [];
  final List<bool> _validateCountry = [];
  bool _isChecked = false;
  bool _savingAttemptedFailed = false;
  final GlobalKey<ShakeWidgetState> _shakeKey = GlobalKey<ShakeWidgetState>();
  List<Map<String, dynamic>> _filteredCountries = [];
  String _searchedValue = "";

  static const String _baseUrl = 'https://dev-api.expatrio.com';

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    for (int i = 0; i < widget.taxResidences.length; i++) {
      _countryControllers.add(TextEditingController(
        text: widget.taxResidences[i].country,
      ));
      _taxIdControllers.add(TextEditingController(
        text: widget.taxResidences[i].id,
      ));

      _validateTaxIdentificationNumber.add(false);
      _validateCountry.add(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    _filteredCountries = _filterCountries(_searchedValue);

    final Size size = MediaQuery.of(context).size;

    return SizedBox(
      height: 600,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Declaration of financial information",
                style: TextStyle(
                    fontSize: size.width > 600 ? 25.0 : 18.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            buildTaxResidenceFields(0, size),
            for (int i = 1; i < widget.taxResidences.length; i++)
              buildTaxResidenceFields(i, size),
            const SizedBox(height: 10),
            _buildAddButton(size),
            const SizedBox(height: 20),
            _buildConfirmationCheckbox(size),
            const SizedBox(height: 20),
            _buildSaveButton(size),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          setState(() {
            TaxResidence newTaxResidence = TaxResidence(country: "", id: "");
            widget.taxResidences.add(newTaxResidence);

            _countryControllers
                .add(TextEditingController(text: newTaxResidence.country));
            _taxIdControllers
                .add(TextEditingController(text: newTaxResidence.id));

            _validateTaxIdentificationNumber.add(false);
            _validateCountry.add(false);
          });
        },
        child: Text("+ ADD ANOTHER",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: size.width > 600 ? 18 : 14.0,
              fontWeight: FontWeight.bold,
              color: kThemeColor,
            )),
      ),
    );
  }

  Widget _buildSaveButton(Size size) {
    return Center(
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: kThemeColor,
              minimumSize: Size(size.width > 600 ? 168.0 : 48.0,
                  size.width > 600 ? 68.0 : 48.0)),
          child: Text('SAVE',
              key: const Key('save'),
              style: TextStyle(fontSize: size.width > 600 ? 22 : 17.0)),
          onPressed: () async {
            if (!_isChecked) {
              _shakeKey.currentState?.shake();
              setState(() {
                _savingAttemptedFailed = true;
              });
            }
            setState(() {
              for (int i = 0; i < _taxIdControllers.length; i++) {
                _taxIdControllers[i].text.isEmpty
                    ? _validateTaxIdentificationNumber[i] = true
                    : _validateTaxIdentificationNumber[i] = false;
              }
              for (int i = 0; i < _countryControllers.length; i++) {
                _countryControllers[i].text.isEmpty
                    ? _validateCountry[i] = true
                    : _validateCountry[i] = false;
              }
            });

            if (_validateTaxIdentificationNumber.contains(true) ||
                _validateCountry.contains(true) ||
                !_isChecked) {
              return;
            }

            try {
              int id = widget.customerID;

              List<Map<String, dynamic>> secondaryTaxResidences = [];
              for (int i = 1; i < widget.taxResidences.length; i++) {
                secondaryTaxResidences.add({
                  "country": widget.taxResidences[i].country,
                  "id": widget.taxResidences[i].id,
                });
              }

              var bodyContent = {
                "primaryTaxResidence": {
                  "country": widget.taxResidences.isNotEmpty
                      ? widget.taxResidences[0].country
                      : "",
                  "id": widget.taxResidences.isNotEmpty
                      ? widget.taxResidences[0].id
                      : "",
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
                  'Authorization': widget.accessToken,
                },
                body: jsonEncode(bodyContent),
              );

              if (response.statusCode == 200) {
                await saveTaxDataLocally({
                  "primaryTaxResidence": {
                    "country": widget.taxResidences.isNotEmpty
                        ? widget.taxResidences[0].country
                        : "",
                    "id": widget.taxResidences.isNotEmpty
                        ? widget.taxResidences[0].id
                        : "",
                  },
                  "secondaryTaxResidence": secondaryTaxResidences,
                });
              } else {
                // Handle other status codes
              }
            } on SocketException {
              // Handle SocketException
            }

            Navigator.pop(context);
          }),
    );
  }

  Widget _buildConfirmationCheckbox(Size size) {
    return ShakeMe(
      key: _shakeKey,
      shakeOffset: 10,
      shakeDuration: const Duration(milliseconds: 500),
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
                return kThemeColor;
              }),
              side: BorderSide(
                  color: !_savingAttemptedFailed ? kThemeColor : Colors.red,
                  width: 2),
              value: _isChecked,
              onChanged: (bool? value) {
                setState(() {
                  _isChecked = value!;
                });
              },
            ),
            Expanded(
              child: Text(
                "I confirm above tax residency and US self-declaration is true and accurate",
                style: TextStyle(fontSize: size.width > 600 ? 20 : 14.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateSelectedCountry(int index) {
    setState(() {
      String? value = _filteredCountries[index]['code'] as String?;
      _countryControllers[index].text = value ?? '';
      widget.taxResidences[index].country = value ?? '';
    });
  }

  Widget buildTaxResidenceFields(int index, Size size) {
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
            style: TextStyle(fontSize: size.width > 600 ? 13 : 10.0),
          ),
        ),
        const SizedBox(height: 10),
        _buildCountryDropdown(index, size),
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
              style: TextStyle(fontSize: size.width > 600 ? 13 : 10.0)),
        ),
        const SizedBox(height: 10),
        _buildTaxIdTextField(index),
        const SizedBox(height: 10),
        if (index != 0) _buildRemoveButton(index, size),
        const SizedBox(height: 20),
      ],
    );
  }

  Align _buildRemoveButton(int index, Size size) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GestureDetector(
          onTap: () {
            setState(() {
              widget.taxResidences.removeAt(index);
              _countryControllers.removeAt(index);
              _taxIdControllers.removeAt(index);
              _validateTaxIdentificationNumber.removeAt(index);
            });
          },
          child: Text("- REMOVE",
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: size.width > 600 ? 18 : 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              )),
        ),
      ),
    );
  }

  Widget _buildTaxIdTextField(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        key: Key('taxIdentificationNumber$index'),
        controller: _taxIdControllers[index],
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
            borderSide: BorderSide(color: kThemeColor),
          ),
          border: const OutlineInputBorder(),
          labelStyle: const TextStyle(
            color: kThemeColor,
          ),
          errorText: _validateTaxIdentificationNumber[index]
              ? 'Field is required'
              : null,
        ),
      ),
    );
  }

  Widget _buildCountryDropdown(int index, Size size) {
    String? selectedCountryCode = _countryControllers[index].text;
    String? selectedCountryLabel = CountriesConstants.nationality.firstWhere(
      (country) => country['code'] == selectedCountryCode,
      orElse: () => {'label': ''},
    )['label'] as String?;

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
    );
  }

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
            Container(
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
            ),
            SearchBox(onChanged: (value) {
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
                            _updateSelectedCountry(index);
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

  Future<void> saveTaxDataLocally(Map<String, dynamic> taxData) async {
    const storage = FlutterSecureStorage();
    await storage.write(
      key: "user_${widget.customerID}_tax_data",
      value: jsonEncode(taxData),
    );
  }
}
