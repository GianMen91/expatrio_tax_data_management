import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../shared/constants.dart';

class TaxDataScreen extends StatefulWidget {
  const TaxDataScreen({super.key});

  @override
  State<TaxDataScreen> createState() => _TaxDataScreenState();
}

class _TaxDataScreenState extends State<TaxDataScreen> {
  TextEditingController taxIdentificationNumberController =
      TextEditingController(text: '');

  TextEditingController countryController = TextEditingController(text: '');

  var _isChecked = false;

  @override
  Widget build(BuildContext context) {
    // Get the size of the current screen
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        key: const Key('app_bar'),
        backgroundColor: Colors.white,
        leading: IconButton(
          key: const Key('arrow_back_icon'),
          icon: Icon(Icons.arrow_back_rounded, size: size.width > 600 ? 38 : 25),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Expanded section containing the Cinnamood logo
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/CryingGirl.svg",
                    fit: BoxFit.contain,
                    width: size.width > 600 ? 600.0 : 150.0,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Uh-Oh"!,
                    style: const TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "We need your tax data in order for you to access your account ",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: themeColor),
                    child: const Text('UPDATE YOUR TAX DATA'),
                    onPressed: () {
                      showTaxForm(context);
                    },
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
            // Align section for displaying developer information
          ],
        ),
      ),
    );
  }


  Future<void> showTaxForm(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 800,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 40),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text("Declaration of financial information",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                      "Which country serves as your primary tax residence?*"
                          .toUpperCase(),
                      style: const TextStyle(fontSize: 10)),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    key: const Key('country'),
                    controller: countryController,
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: themeColor),
                      ),
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(
                        color: themeColor,
                      ),
                      /*errorText:
                                        _validateEmail ? 'Email Can\'t Be Empty' : null,*/
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
                  child: TextField(
                    key: const Key('taxIdentificationNumber'),
                    controller: taxIdentificationNumberController,
                    decoration: const InputDecoration(
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
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 25.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: const Text("+ ADD ANOTHER",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: themeColor,
                        )),
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      checkColor: Colors.white,
                      //fillColor: MaterialStateProperty.resolveWith(),
                      value: _isChecked,
                      onChanged: (bool? value) async {
                        setState(() {
                          _isChecked = value!;
                        });
                      },
                    ),
                    const Text(
                        "I confirm above tax residency and US self-declaration is true and accurate"),
                  ],
                ),
                ElevatedButton(
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
              ],
            ),
          ),
        );
      },
    );
  }
}
