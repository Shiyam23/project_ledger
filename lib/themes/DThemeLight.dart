import 'package:flutter/material.dart';

import 'DTheme.dart';

class DThemeLight implements DTheme {
  final ThemeData _themeData = ThemeData(
    brightness: Brightness.light,
    primarySwatch: MaterialColor(0xff2f3840, <int, Color>{
      50: Color(0xff7a8085),
      100: Color(0xff676e74),
      200: Color(0xff545c62),
      300: Color(0xff414a51),
      400: Color(0xff2f3840),
      500: Color(0xff2b333b),
      600: Color(0xff272e35),
      700: Color(0xff23292f),
      800: Color(0xff1e2429),
      900: Color(0xff1a1f23),
    }),
    canvasColor: Color(0xfff0f1f5),
  );

  ThemeData get themeData => _themeData;
}
