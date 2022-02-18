import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomColors {
//static Color unpaidLabel= Color(0xff);
  static const Color paidLabel = Color(0xffffffff);
//static Color unpaidText=Color(0xff);
  static const Color paidText = Color(0xff040105);
  static const Color cardColor = Color(0xffffffff);
  static const Color textColorPrimary = Color(0xff000000);
  static const Color textColorSecondary = Color(0xff514E4E);
  static const Color accentColors = Color(0xff880E4F);
  static const Color backgrounColor = Color(0xffE5E5E5);

  static const MaterialColor accentColorMaterial = MaterialColor(
    _accentColorMaterial,
    <int, Color>{
      50: Color(0xff880E4F),
      100: Color(0xff880E4F),
      200: Color(0xff880E4F),
      300: Color(0xff880E4F),
      400: Color(0xff880E4F),
      500: Color(_accentColorMaterial),
      600: Color(0xff880E4F),
      700: Color(0xff880E4F),
      800: Color(0xff880E4F),
      900: Color(0xff880E4F),
    },
  );

  static const int _accentColorMaterial = 0xff880E4F;
}

class CustomText {
  static TextStyle textTitle = GoogleFonts.poppins(
      textStyle:
          const TextStyle(color: CustomColors.textColorPrimary, fontSize: 20),
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.none);
  static TextStyle textSubTitle = GoogleFonts.poppins(
      textStyle:
          const TextStyle(color: CustomColors.textColorPrimary, fontSize: 16),
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.none);
  static TextStyle textDescription = GoogleFonts.poppins(
      textStyle:
          const TextStyle(color: CustomColors.textColorSecondary, fontSize: 12),
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);
  static TextStyle customText = GoogleFonts.poppins(
      textStyle: const TextStyle(color: Colors.white, fontSize: 14),
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);
}

class IconLogo {
  IconLogo._();

  static const _kFontFam = 'MyFlutterApp';
  static const String? _kFontPkg = null;

  static const IconData group_2 =
      IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}
