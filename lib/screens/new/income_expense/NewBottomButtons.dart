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
          style: ElevatedButton.styleFrom(
            minimumSize: Size(
              MediaQuery.of(context).size.width * 0.3, 
              MediaQuery.of(context).size.width * 0.1, 
            )
          ),
          child: Text(
            "Zurücksetzen",
            style: TextStyle(fontSize: 15),
          ),
          onPressed: onReset ,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(
              MediaQuery.of(context).size.width * 0.3, 
              MediaQuery.of(context).size.width * 0.1, 
            )
          ),
          child: Text(
            "Speichern",
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          onPressed: onSave,
        ),
      ],
    );
  }
}
