import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewSaveAsTemplate extends StatelessWidget {

  final void Function(bool checked) setTemplateChecked;
  final bool initialChecked;

  NewSaveAsTemplate(
    this.setTemplateChecked,
    this.initialChecked
  );
  
  @override
  Widget build(BuildContext context) {
    bool _checked = false;
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Transform.scale(
            alignment: Alignment.centerLeft,
            scale: 1.1,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Checkbox(
                  value: _checked,
                  onChanged: (checked) {
                    setTemplateChecked(checked!);
                    setState(() => _checked = checked);
                  } ,
                );
              } 
            )
          ),
          Transform.scale(
            alignment: Alignment.centerLeft,
            scale: 1.1,
            child: Text(
              AppLocalizations.of(context)!.saveAsTemplate,
              textAlign: TextAlign.left, 
              style: TextStyle(fontSize: 15)
            ),
          ),
        ],
      ),
    );
  }
}
