// Import necessary packages and files
import 'package:coding_challenge/services/tax_data_service.dart';
import 'package:coding_challenge/widgets/tax_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../shared/constants.dart';

// Screen for displaying tax-related data
class TaxDataScreen extends StatefulWidget {
  // Constructor for creating a TaxDataScreen instance
  const TaxDataScreen({
    super.key,
    required this.customerId,
    required this.accessToken,
  });

  final String accessToken; // Access token for authentication
  final int customerId; // Customer ID associated with the user

  @override
  State<TaxDataScreen> createState() => _TaxDataScreenState();
}

class _TaxDataScreenState extends State<TaxDataScreen> {
  @override
  Widget build(BuildContext context) {
    // Get the size of the current screen
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  // SVG image depicting a crying girl
                  SvgPicture.asset(
                    "assets/CryingGirl.svg",
                    width: size.width > 600 ? 300.0 : 150.0,
                  ),
                  SizedBox(height: size.width > 600 ? 35 : 15),
                  Text(
                    "Uh-Oh!",
                    style: TextStyle(
                      fontSize: size.width > 600 ? 40.0 : 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: size.width > 600 ? 30 : 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "We need your tax data for you to access your account.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: size.width > 600 ? 20.0 : 16.0,
                      ),
                    ),
                  ),
                  SizedBox(height: size.width > 600 ? 35 : 15),
                  _buildUpdateTaxDataButton(size, context),
                ],
              ),
            ),
            // Align section for displaying developer information
          ],
        ),
      ),
    );
  }

  // Widget for the "UPDATE YOUR TAX DATA" button
  ElevatedButton _buildUpdateTaxDataButton(Size size, BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: kThemeColor,
        minimumSize: Size(
            size.width > 600 ? 168.0 : 48.0, size.width > 600 ? 68.0 : 48.0),
      ),
      child: Text('UPDATE YOUR TAX DATA',
          style: TextStyle(fontSize: size.width > 600 ? 22 : 14.0)),
      onPressed: () async {
        if (context.mounted) {
          showModalBottomSheet<void>(
            isScrollControlled: true,
            context: context,
            constraints: const BoxConstraints(
              minWidth: double.infinity,
            ),
            builder: (BuildContext context) {
              return FutureBuilder(
                // Fetch tax data asynchronously
                future: TaxDataService.getTaxData(
                    widget.customerId, widget.accessToken),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    // While waiting for the response, show CircularProgressIndicator
                    return const Center(
                      child: CircularProgressIndicator(color: kThemeColor),
                    );
                  } else if (snapshot.hasError) {
                    // Show an error message if there's an issue with the data retrieval
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.data!.isNotEmpty) {
                    // Display tax form widget if tax data is available
                    return TaxFormWidget(
                      snapshot.data!,
                      widget.accessToken,
                      widget.customerId,
                    );
                  } else {
                    // Display a message if no tax data is available
                    return const Text('No tax data available.');
                  }
                },
              );
            },
          );
        }
      },
    );
  }
}
