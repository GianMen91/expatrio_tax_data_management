import 'package:coding_challenge/search_box.dart';
import 'package:coding_challenge/shared/countries_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../shared/constants.dart';
import 'package:coding_challenge/models/taxResidence.dart';

class TaxFormWidget extends StatefulWidget {
  final List<TaxResidence> taxResidences;

  const TaxFormWidget(this.taxResidences, {Key? key}) : super(key: key);

  @override
  State<TaxFormWidget> createState() => _TaxFormWidgetState();
}

class _TaxFormWidgetState extends State<TaxFormWidget> {
  List<TextEditingController> countryControllers = [];
  List<TextEditingController> taxIdControllers = [];
  var _checked = false;

  List<Map<String, dynamic>> filteredCountries = [];

  String _searchedValue = "";

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
            for (int i = 0; i < widget.taxResidences.length; i++)
              buildTaxResidenceFields(i),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () {},
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
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () {},
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
            Padding(
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
                    side: const BorderSide(color: themeColor, width: 2),
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
                onPressed: () async {},
              ),
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
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            "Which country serves as your primary tax residence?*"
                .toUpperCase(),
            style: const TextStyle(fontSize: 10),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            height: 35.0,
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: false,
                  backgroundColor: Colors.transparent,
                  builder: (BuildContext context) => StatefulBuilder(
                    builder: (context, state) => Container(
                      constraints: BoxConstraints(
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
                                mainAxisAlignment: MainAxisAlignment
                                    .center, // Center alignment
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
                              filteredCountries =
                                  filterCountries(_searchedValue);
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
                                          // Call the callback function to update the state
                                          updateSelectedCountry(
                                              country['code'] as String?);
                                          Navigator.pop(
                                              context); // Close the bottom sheet
                                        },
                                      );
                                    },
                                  )
                                : Center(
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
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
          child: SizedBox(
            height: 35.0,
            child: TextField(
              key: Key('taxIdentificationNumber$index'),
              controller: taxIdControllers[index],
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: themeColor),
                ),
                border: OutlineInputBorder(),
                labelStyle: TextStyle(
                  color: themeColor,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  List<Map<String, dynamic>> filterCountries(String searchValue) {
    return CountriesConstants.nationality
        .where((country) => country['label']
            .toString()
            .toLowerCase()
            .contains(searchValue.toLowerCase()))
        .toList();
  }
}
