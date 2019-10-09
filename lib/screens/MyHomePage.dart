import 'package:flutter/material.dart';

import 'package:project_ez_finance/themes/DTheme.dart';
import 'package:project_ez_finance/themes/DThemeDark.dart';
import 'package:project_ez_finance/themes/DThemeLight.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dollavu", style: DTheme.of(context)?.inivisText),
        actions: <Widget>[
          Icon(Icons.more_vert),
        ],
      ),
      body: Center(
        child: Text("test"),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            child: Text("L"),
            onPressed: () {
              DTheme.switchTheme(context: context, newDTheme: DThemeLight());
            },
          ),
          FloatingActionButton(
            child: Text("D"),
            onPressed: () {
              DTheme.switchTheme(context: context, newDTheme: DThemeDark());
            },
          ),
        ],
      ),
    );
  }
}
