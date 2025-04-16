import 'dart:ui';

class AppColors {
  static const Color backgroundColor = Color.fromARGB(
    255,
    58,
    44,
    136,
  ); // Updated

  static const Color chipsChoiceUnSelected = Color.fromARGB(
    255,
    94,
    80,
    198,
  ); // Slightly brighter than background
  static const Color foreground = Color.fromARGB(
    255,
    15,
    9,
    57,
  ); // Darker foreground for contrast
  static const Color chipsChoiceSelected = Color.fromARGB(
    255,
    150,
    123,
    255,
  ); // Brighter lavender for selection
  static const Color background2 = Color.fromARGB(
    255,
    255,
    255,
    255,
  ); // Keeping white for contrast
  static const Color textColor = Color.fromARGB(
    255,
    240,
    240,
    255,
  ); // Slightly softened white for main text

  static const Color weekendLabelColor = Color.fromARGB(
    255,
    221,
    221,
    255,
  ); // Slight lavender tint
  static const Color weekdaysLabelColor = Color.fromARGB(
    255,
    255,
    251,
    255,
  ); // Subtle off-white

  static const Color calenderBackgroundColor = Color.fromARGB(
    255,
    38,
    26,
    104,
  ); // Complementary with new background
  static const Color clockBackgroundColor = Color.fromARGB(
    255,
    30,
    18,
    109,
  ); // Slightly different shade for clock
  static const Color clockForegroundColor = Color.fromARGB(255, 83, 67, 192);
  static const Color backAndNextButton = Color.fromARGB(
    255,
    96,
    84,
    185,
  ); // Muted purple, stands out from background

  static const List<Color> highlightedDateColor = [
    Color.fromARGB(57, 85, 55, 255),
    Color.fromARGB(57, 155, 55, 255),
    Color.fromARGB(57, 55, 235, 255),
  ]; // Transparent vibrant highlight
  static const List<Color> highlightedDateTextColor = [
    Color.fromARGB(255, 89, 89, 172),
    Color.fromARGB(255, 133, 84, 170),
    Color.fromARGB(255, 84, 154, 170),
  ]; // Darker text for readability
  static const Color bottomSurveyBarColor = Color.fromARGB(255, 31, 31, 93);
  static const Color shadowColor = Color.fromARGB(36, 31, 31, 93);
  static const Color backAndNextIconColor = Color.fromARGB(255, 32, 32, 119);
  // High contrast for readability

  static const Color studyPatchColor = Color.fromARGB(255, 145, 130, 255);

  static const List<Color> foregroundGradient = [
    Color.fromARGB(255, 253, 252, 255), // Light pastel
    Color.fromARGB(255, 236, 234, 255), // Matching fade
  ];

  static const List<Color> backgroundDarkGradient = [
    Color.fromARGB(255, 48, 36, 118), // Light pastel
    Color.fromARGB(255, 96, 42, 142), // Light pastel
  ];

  // static const Color backgroundColor = Color.fromARGB(255, 34, 31, 79);
  // static const Color chipsChoiceUnSelected = Color.fromARGB(255, 14, 5, 64);
  // static const Color foreground = Color.fromARGB(255, 11, 3, 57);
  // static const Color chipsChoiceSelected = Color.fromARGB(255, 154, 138, 241);
  // static const Color background2 = Color.fromARGB(255, 255, 255, 255);
  // // static const Color background2 = Color.fromARGB(255, 252, 245, 255);
  // static const Color textColor = Color.fromARGB(255, 255, 255, 255);
  // static const Color weekendLabelColor = Color.fromARGB(255, 217, 217, 217);
  // static const Color weekdaysLabelColor = Color.fromARGB(255, 255, 249, 249);
  // static const Color tableBackgroundColor = Color.fromARGB(255, 53, 50, 103);
  // static const Color clockBackgroundColor = Color.fromARGB(255, 54, 51, 113);
  // static const Color backAndNextButton = Color.fromARGB(255, 48, 43, 124);
  // static const Color highlightedDateColor = Color.fromARGB(40, 3, 168, 244);
  // static const Color highlightedDateTextColor = Color.fromARGB(255, 0, 94, 138);
  // static const List<Color> foregroundGradient = [
  //   Color.fromARGB(255, 250, 248, 255),
  //   Color.fromARGB(255, 244, 239, 255),
  // ];
}
