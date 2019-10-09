import 'package:flutter/material.dart';

import 'DTheme.dart';

class DThemeLight implements DTheme {
  ThemeData get td => ThemeData(backgroundColor: Colors.green);
  TextStyle get inivisText => TextStyle(color: Colors.deepPurpleAccent);
}
