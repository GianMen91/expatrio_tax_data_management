import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../shared/constants.dart';

class HelpButton extends StatelessWidget {
  const HelpButton({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                maximumSize: Size(
                    size.width > 600 ? 130 : 100, size.width > 600 ? 530 : 130),
              ),
              onPressed: () {
                // Open the link in the browser
                launchUrl(Uri.parse('https://help.expatrio.com/hc/en-us'));
              },
              child: Row(
                children: [
                  Icon(CupertinoIcons.question_circle,
                      color: kThemeColor, size: size.width > 600 ? 28 : 20),
                  Text(
                    'Help',
                    style: TextStyle(
                      fontSize: size.width > 600 ? 22 : 10.0,
                      color: kThemeColor,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
