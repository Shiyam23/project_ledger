import 'package:flutter/material.dart';

class NewBottonButtons extends StatelessWidget {
  final void Function()? onSave;
  final void Function()? onReset;
  
  NewBottonButtons({this.onSave, this.onReset});

  @override
  Widget build(BuildContext context) {
    return ButtonBar(
      mainAxisSize: MainAxisSize.max,
      alignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            fixedSize: Size(
              MediaQuery.of(context).size.width * 0.3,
              MediaQuery.of(context).size.width * 0.1,
            )
          ),
          icon: Icon(Icons.restore),
          label: Text(
            "RESET",
          ),
          onPressed: onReset,
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            fixedSize: Size(
              MediaQuery.of(context).size.width * 0.3,
              MediaQuery.of(context).size.width * 0.1,
            )
          ),
          icon: Icon(Icons.save),
          label: Text(
            "SAVE",
          ),
          onPressed: onSave,
        ),
      ],
    );
  }
}
