import 'package:flutter/material.dart';

class AppTheme {
  ///Colors
  static const Color white = Colors.white;
  static const Color dirtyWhite = Color(0xFFF9F9F9);
  static const Color ceramic = Color(0x33D9D9D9);
  static const Color black = Colors.black;
  static const Color errorColor = Colors.red;
  static const Color primary = Color(0xFF115DA9);
  static const Color tertiary = Color(0xFFFF9912);
  static const Color lightPrimary = Color(0xFFEBF5FF);
  static const Color text = Color(0xFF090A0A);
  static const Color greyText = Color(0xFF6C7072);
  static const Color grey100 = Color(0xFF454545);
  static const Color lightText = Color(0xFF72777A);

  ///Styles
  static const TextStyle h0 = TextStyle(
    color: black,
    fontFamily: 'Lato',
    fontSize: 32,
    height: 38.4 / 32,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle h1 = TextStyle(
    color: text,
    fontFamily: 'Poppins',
    fontSize: 24,
    height: 36 / 24,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle countryCodeStyle = TextStyle(
    color: text,
    fontFamily: 'Poppins',
    fontSize: 14,
    height: 16 / 14,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle phoneNumberInputStyle = TextStyle(
    color: text,
    fontFamily: 'Poppins',
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle otpInstructionsStyle = TextStyle(
    color: greyText,
    fontFamily: 'Lato',
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle cropDoctorResultsStyle = TextStyle(
    color: grey100,
    fontFamily: 'Lato',
    fontSize: 12,
    height: 18 / 12,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle h3 = TextStyle(
    color: white,
    fontFamily: 'Poppins',
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle googleButtonStyle = TextStyle(
    color: lightText,
    fontFamily: 'Lato',
    fontSize: 14,
    height: 16 / 14,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle appBarStyle = TextStyle(
    color: text,
    fontFamily: 'Poppins',
    fontSize: 20,
    height: 16 / 20,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle cropDoctorResultStateStyle = TextStyle(
    color: white,
    fontFamily: 'Poppins',
    fontSize: 8,
    height: 12 / 8,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle selectLanguageStyle = TextStyle(
    color: text,
    fontFamily: 'Lato',
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle readMoreStyle = TextStyle(
    color: Color(0xFF949494),
    fontFamily: 'Lato',
    fontSize: 8,
    height: 16 / 8,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.underline,
  );
  static const TextStyle vendorDataTitleStyle = TextStyle(
    color: primary,
    fontFamily: 'Lato',
    fontSize: 14,
    height: 18 / 14,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle minMaxTempStyle = TextStyle(
    color: Color(0xFF949494),
    fontFamily: 'Lato',
    fontSize: 10,
    height: 12 / 10,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle cropPriceStyle = TextStyle(
    color: primary,
    fontFamily: 'Lato',
    fontSize: 16,
    height: 19.2 / 16,
    fontWeight: FontWeight.w400,
  );

  ///Defined only for use by `MyApp`. Do not use directly.
  static final ThemeData theme = ThemeData.from(
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      background: white,
      brightness: Brightness.light,
    ),
  );
}
