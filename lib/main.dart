import 'package:flutter/material.dart';
import 'package:project_ez_finance/screens/MyHomePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test App',
      theme: ThemeData.from(
        colorScheme: ColorScheme.light(
          primary: Color(0xff2f3840),
          primaryVariant: Color(0xff23292f),
          background: Color(0xfff0f1f5),
          onBackground: Color(0xff2f3840),
        ),
        textTheme: TextTheme(),
      ),
      home: MyHomePage(),
    );
  }
}
