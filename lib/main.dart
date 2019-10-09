import 'package:flutter/material.dart';

import 'package:project_ez_finance/screens/MyHomePage.dart';

import 'package:project_ez_finance/themes/DTheme.dart';
import 'package:project_ez_finance/themes/DThemeLight.dart';
import 'package:project_ez_finance/themes/test.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DThemeContainer(
      initialDTheme: DThemeLight(),
      child: MaterialApp(
        title: 'Dollavu',
        theme: DTheme.of(context)?.td,
        home: MyHomePage(),
      ),
    );
  }
}
