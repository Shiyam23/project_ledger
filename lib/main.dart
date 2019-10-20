import 'package:flutter/material.dart';

import 'package:project_ez_finance/screens/Layout.dart';

import 'package:project_ez_finance/themes/DTheme.dart';
import 'package:project_ez_finance/themes/DThemeLight.dart';

void main() => runApp(DThemeContainer(
      initialDTheme: DThemeLight(),
      child: MyApp(),
    ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dollavu',
      theme: DTheme.of(context)?.themeData,
      home: Layout(),
      debugShowCheckedModeBanner: false,
    );
  }
}
