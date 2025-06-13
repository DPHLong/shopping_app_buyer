import 'package:flutter/material.dart';

/// Base colors used across the app (and whitelabels).
class BaseColors {
  static const blackDull = Color(0xB34E5858);
  static const blackDullOpaque = Color(0xFF4E5858);
  static const blackDullTranslucent = Color(0x804E5858);
  static const blackDullTranslucentDark = Color(0xE64E5858);
  static const gold = Color(0xFFB7892D);
  static const goldLight = Color.fromARGB(255, 255, 216, 139);
  static const gray65 = Color(0xFF656565);
  static const grayBlack = Color(0x664E5858);
  static const grayMild = Color(0xB396A8A9);
  static const grayMildOpaque = Color(0xFF96A8A9);
  static const whiteF8 = Color(0xFFF8F8F8);
  static const whiteFd = Color(0xFFFDFDFD);
  static const whiteSplit = Color(0xFFE8ECEC);
  static const whiteTertiary = Color(0xFFF2F3F3);
}

class BrandColors {
  static const primary = BaseColors.gold;
  static const primaryDark = Color.fromARGB(255, 133, 92, 10);
  static const primaryLight = Color.fromARGB(255, 255, 216, 139);
  static const primaryTranslucent = Color(0x96B7892D);
  static const secondary = BaseColors.gray65;
  static const secondaryTranslucent = Color(0x96656565);
}

/// @deprecated
class MainColors {
  static const primary = Color(0xFF6FC8FC);
  static const primaryDark = Color(0xFF568FB0);
  static const primaryLight = Color(0xFFA4DDFF);
  static const primaryTranslucent = Color(0xCC6FC8FC);
  static const primaryDarkTranslucent = Color(0xD9568FB0);
  static const secondary = Color(0xFFFC888C);
  static const secondaryDark = Color(0xFFFF757A);
  static const privateColor = BrandColors.primary;
  static const guestColor = primaryDarkTranslucent;
  static const bg = Color(0xFFFDFDFD);
  static const bgAppbar = Color(0xFFF9F9F9);
  static const bgSecondary = Color(0xFFF8F8F8);
  static const bgSplit = Color(0xFFE8ECEC);
  static const bgTertiary = Color(0xFFF2F3F3);
  static const bgFilter = Color(0xFFF7F7F7);
  static const fontPrimary = Color(0xFF000000);
  static const fontPrimaryTranslucent = Color(0xD9000000);
  static const fontSecondary = Color(0xFF4E5858);
  static const fontTertiary = Color(0xFF96A8A9);
  static const fontError = Color(0xFFFF2323);
  static const fontContrast = Color(0xFF000000);
  static const cardColor = Color(0xFFFDFDFD);
  static const shadow = Color(0x67252729);
  static const lighterPeach = Color(0xFFFABFC1);
  static const lightPeach = Color(0xB3FF5A5F);
  static const lightpeachB = Color(0xFFFC888C);
  static const peach = Color(0xFFFF5A5F);
  static const peachTranslucent = Color(0xCCFF5A5F);
  static const peachTranslucentDark = Color(0xD9FF5A5F);
  static const red = Color(0xFFFF2323);
  static const lightBlue = Color(0xB38CC6FF);
  static const lighterBlue = Color(0xB3ADD6FE);
  static const mildGray = Color(0xB396A8A9);
  static const mildGrayOpaque = Color(0xFF96A8A9);
  static const lightGray = Color(0xFFF8F8F8);
  static const grayBlack = Color(0x664E5858);
  static const dullBlack = Color(0xB34E5858);
  static const dullBlackOpaque = Color(0xFF4E5858);
  static const dullBlackTranslucent = Color(0x804E5858);
  static const dullBlackTranslucentDark = Color(0xE64E5858);
}
