import 'package:flutter/material.dart';
import 'package:project_ez_finance/components/button/Button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
        WhiteRoundButton(
          onPressed: onReset, 
          text: AppLocalizations.of(context)!.reset,
          widthRatio: 0.4,
          fontSizeFactor: 0.8,
        ),
        RoundGradientButton(
          onPressed: onSave,
          text: MaterialLocalizations.of(context).saveButtonLabel,
          widthRatio: 0.4,
          fontSizeFactor: 0.8,
        )
      ],
    );
  }
}
