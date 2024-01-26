import 'package:number_to_words_english/number_to_words_english.dart';

String getOrdinal(int number) {
  if (number == 1) {
    return 'first';
  } else if (number == 2) {
    return 'second';
  } else if (number == 3) {
    return 'third';
  } else if (number == 5) {
    return 'fifth';
  } else if (number == 9) {
    return 'ninth';
  } else {
    String words = NumberToWordsEnglish.convert(number);
    if (number > 10) {
      if (number % 10 == 0) {
        int lastYIndex = words.lastIndexOf('y');
        if (lastYIndex != -1) {
          words = words.replaceRange(lastYIndex, lastYIndex + 1, 'i');
        }
        return '${words.toLowerCase()}eth';
      }
      else {
        List<String> parts = words.split('-');
        String firstPart = parts[0];
        int secondDigits = convertWordToNumber(parts[1]);
        String secondPart = getOrdinal(secondDigits);
        return "$firstPart-$secondPart";
      }
    }
    return '${words.toLowerCase()}th';
  }
}

int convertWordToNumber(String word) {
  switch (word.toLowerCase()) {
    case 'one':
      return 1;
    case 'two':
      return 2;
    case 'three':
      return 3;
    case 'four':
      return 4;
    case 'five':
      return 5;
    case 'six':
      return 6;
    case 'seven':
      return 7;
    case 'eight':
      return 8;
    case 'nine':
      return 9;
  // Add more cases for other numbers as needed
    default:
    // Handle the case where the word is not recognized
      throw FormatException('Invalid word representation of a number: $word');
  }
}