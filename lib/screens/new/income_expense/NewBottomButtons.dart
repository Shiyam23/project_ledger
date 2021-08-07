import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class NewBottonButtons extends StatelessWidget {
  final void Function()? onSave;
  final void Function()? onReset;

  NewBottonButtons({this.onSave, this.onReset});

  @override
  Widget build(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        ElevatedButton(
          child: Text(
            "Zurücksetzen",
            style: TextStyle(fontSize: 15),
          ),
          onPressed: onReset ,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(),
          child: Text(
            "Speichern",
            style: TextStyle(fontSize: 15),
          ),
          onPressed: onSave,
        ),
      ],
    );
  }
}
