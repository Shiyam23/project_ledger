import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'DTheme.dart';

class DThemeLight implements DTheme {
  
  static Color primaryColor = Color(0xff2f3840);
  static Color secondaryColor = Color(0xFF386484);
  static Color tertiaryColor = Color(0xBF386484);

  final ThemeData _themeData = ThemeData(
    appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: primaryColor),
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
    bottomAppBarColor: primaryColor,
    tabBarTheme: TabBarTheme(
        labelPadding: EdgeInsets.only(top: 15, bottom: 7.5),
        unselectedLabelStyle:
            TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
  );

  ThemeData get themeData => _themeData.copyWith(
    colorScheme: _themeData.colorScheme.copyWith(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: tertiaryColor
    )
  );
}
