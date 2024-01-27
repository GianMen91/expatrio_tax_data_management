// Import necessary packages and files
import 'package:coding_challenge/shared/constants.dart';
import 'package:flutter/material.dart';

// Define a stateless widget for the search box
class SearchBox extends StatelessWidget {
  // Constructor with required parameter
  const SearchBox({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  // Callback function for handling text changes
  final ValueChanged onChanged;

  // Build method to create the widget UI
  @override
  Widget build(BuildContext context) {
    // Get the size of the current screen
    final Size size = MediaQuery.of(context).size;

    // Return a container with a styled text field for searching
    return Container(
      key: const Key('search_box_container'),
      margin: const EdgeInsets.all(defaultPadding),
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 4, // 5 top and bottom
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: themeColor), // Set the border color to black
      ),
      child: TextField(
        key: const Key('search_text_field'),
        onChanged: onChanged,
        style: TextStyle(
          color: Colors.black,
          fontSize: size.width > 600 ? 25.0 : 14.0,
        ),
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          icon: Icon(
            Icons.search,
            key: const Key('search_icon'),
            color: Colors.black54,
            size: size.width > 600 ? 38 : 25,
          ),
          hintText: 'Search for country',
          hintStyle: const TextStyle(color: Colors.black54),
        ),
      ),
    );
  }
}
