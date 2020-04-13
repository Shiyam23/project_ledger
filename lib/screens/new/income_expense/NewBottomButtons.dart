import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class NewBottonButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        MaterialButton(
          child: Text(
            "Zurücksetzen",
            style: TextStyle(fontSize: 15),
          ),
          onPressed: () => null,
          color: Theme.of(context).colorScheme.primary,
          textColor: Colors.white,
          minWidth: MediaQuery.of(context).size.width / 3,
          height: 45,
        ),
        MaterialButton(
          child: Text(
            "Speichern",
            style: TextStyle(fontSize: 15),
          ),
          onPressed: () => null,
          color: Theme.of(context).colorScheme.primary,
          textColor: Colors.white,
          minWidth: MediaQuery.of(context).size.width / 3,
          height: 45,
        ),
      ],
    );
  }
}
