import 'package:flutter/material.dart';
import 'package:project_ez_finance/components/button/Button.dart';

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
        RoundButton(
          onPressed: onReset, 
          text: "RESET",
          widthRatio: 0.4,
        ),
        RoundGradientButton(
          widthRatio: 0.4,
          onPressed: onSave, 
          text: "SAVE"
        )
      ],
    );
  }
}
