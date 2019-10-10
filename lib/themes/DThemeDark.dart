import 'package:flutter/material.dart';

import 'DTheme.dart';

class DThemeDark implements DTheme {
  final ThemeData _themeData = ThemeData(
    brightness: Brightness.light,
    primarySwatch: MaterialColor(0xff161a1e, <int, Color>{
      50: Color(0xff6a6d6f),
      100: Color(0xff55585b),
      200: Color(0xff404346),
      300: Color(0xff2b2e32),
      400: Color(0xff161a1e),
      500: Color(0xff14181c),
      600: Color(0xff131619),
      700: Color(0xff111316),
      800: Color(0xff0f1114),
      900: Color(0xff0c0f11),
    }),
    canvasColor: Color(0xff2f3840),
  );

  ThemeData get themeData => _themeData;
}
