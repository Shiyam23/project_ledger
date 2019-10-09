import 'package:flutter/material.dart';

import 'DTheme.dart';

class DThemeDark implements DTheme {
  ThemeData get td => ThemeData(backgroundColor: Colors.red);
  TextStyle get inivisText => TextStyle(color: Colors.red);
}
