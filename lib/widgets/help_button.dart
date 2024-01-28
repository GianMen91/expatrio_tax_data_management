// Import necessary packages and libraries
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Import local dependencies
import '../shared/constants.dart';

// A custom widget representing a help button with a link to an external URL
class HelpButton extends StatelessWidget {
  // Constructor for the HelpButton widget
  const HelpButton({
    super.key,
    required this.size,
  });

  // Size parameter to determine the layout of the button
  final Size size;

  // Build method for the widget
  @override
  Widget build(BuildContext context) {
    // Return an aligned help button at the bottom center of the screen
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(left:20.0),
        child: Row(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Button background color
              ),
              onPressed: () {
                // Open the link in the browser when the button is pressed
                launchUrl(Uri.parse('https://help.expatrio.com/hc/en-us'));
              },
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.question_circle, // Question mark icon
                    color: kThemeColor, // Icon color
                    size: size.width > 600 ? 28 : 20, // Icon size
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Help', // Button text
                    style: TextStyle(
                      fontSize: size.width > 600 ? 22 : 10.0, // Text font size
                      color: kThemeColor, // Text color
                    ),
                  ),
                ],
              ),
            ),// Empty space to push the button to the right
          ],
        ),
      ),
    );
  }
}
