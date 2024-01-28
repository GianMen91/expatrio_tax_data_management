import 'package:coding_challenge/search_box.dart';
import 'package:coding_challenge/shared/countries_constants.dart';
import 'package:coding_challenge/tax_data_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shakemywidget/flutter_shakemywidget.dart';
import '../shared/constants.dart';
import 'package:coding_challenge/models/tax_residence.dart';


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

  Widget buildTaxResidenceFields(int index, Size size) {
    String? selectedCountryCode = _countryControllers[index].text;

    String? selectedCountryLabel = CountriesConstants.nationality.firstWhere(
          (country) => country['code'] == selectedCountryCode,
      orElse: () => {'label': ''},
    )['label'] as String?;

    void updateSelectedCountry(String? value) {
      setState(() {
        selectedCountryCode = value;
        _countryControllers[index].text = value ?? '';
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
            style:  TextStyle(fontSize: size.width > 600 ? 13 : 10.0),
          ),
        ),
        const SizedBox(height: 10),
        _buildCountryDropdown(size, updateSelectedCountry, index, selectedCountryLabel),
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
        if (index != 0)
          _buildRemoveButton(index, size),
        const SizedBox(height: 20),
      ],
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

            await TaxDataService.handleSaving(widget.customerID, widget.accessToken, widget.taxResidences);

            Navigator.pop(context);
          }),
    );
  }

  Widget _buildRemoveButton(int index, Size size) {
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
          child:  Text("- REMOVE",
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

  Widget _buildCountryDropdown(Size size, void Function(String? value) updateSelectedCountry, int index, String? selectedCountryLabel) {
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
              builder: (BuildContext context) => _buildCountrySelectionSheet(size, updateSelectedCountry),
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

  Widget _buildCountrySelectionSheet(Size size, void Function(String? value) updateSelectedCountry) {
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
                      child:  Padding(
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
