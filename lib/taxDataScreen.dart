import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import '../shared/constants.dart';

class TaxDataScreen extends StatefulWidget {
  const TaxDataScreen({super.key});

  @override
  State<TaxDataScreen> createState() => _TaxDataScreenState();
}

class _TaxDataScreenState extends State<TaxDataScreen> {
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
          icon:
              Icon(Icons.arrow_back_rounded, size: size.width > 600 ? 38 : 25),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/CryingGirl.svg",
                    width: size.width > 600 ? 600.0 : 150.0,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Uh-Oh!",
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "We need your tax data in order for you to access your account ",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: themeColor),
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
        return const TaxFormWidget();
      },
    );
  }
}

class TaxFormWidget extends StatefulWidget {
  const TaxFormWidget({super.key});

  @override
  State<TaxFormWidget> createState() => _TaxFormWidgetState();
}

class _TaxFormWidgetState extends State<TaxFormWidget> {
  TextEditingController taxIdentificationNumberController =
      TextEditingController(text: '');

  TextEditingController countryController = TextEditingController(text: '');

  var _checked = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 600,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Ensure the crossAxisAlignment is set to start

          children: <Widget>[
            const SizedBox(height: 40),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text("Declaration of financial information",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
              child:  SizedBox(
                height: 35.0,
                child: TextField(
                key: const Key('country'),
                controller: countryController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
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
              )
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
                  key: const Key('taxIdentificationNumber'),
                  controller: taxIdentificationNumberController,
                  keyboardType: TextInputType.number, // Limit keyboard to numeric input
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly, // Allow only numeric input
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
                  Expanded(
                    child: const Text(
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return themeColor;
  }
}
