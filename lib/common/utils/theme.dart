import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

MaterialColor primaryClrMaterial = bluishClrMaterial;

class Themes {
  static final light = ThemeData(
    brightness: Brightness.light,
    primarySwatch: primaryClrMaterial,
    appBarTheme: const AppBarTheme(
      backgroundColor: whiteClr,
    ),
    useMaterial3: true,
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: darkGreyClrMaterial,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkGreyClr,
    ),
    useMaterial3: true,
  );
}

TextStyle get subHeadingStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 24,
      color: Get.isDarkMode ? Colors.grey[400] : greyClr,
    ),
  );
}

TextStyle get headingStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: Get.isDarkMode ? whiteClr : blackClr,
    ),
  );
}

TextStyle get titleStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Get.isDarkMode ? whiteClr : blackClr,
    ),
  );
}

TextStyle get subTitleStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Get.isDarkMode ? Colors.grey[100] : Colors.grey[600],
    ),
  );
}
