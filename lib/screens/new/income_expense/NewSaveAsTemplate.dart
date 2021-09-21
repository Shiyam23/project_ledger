import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Transform.scale(
          alignment: Alignment.centerLeft,
          scale: 1.3,
          child: Text(
            "Save as template",
            textAlign: TextAlign.left, 
            style: TextStyle(fontSize: 15)
          ),
        ),
        Transform.scale(
          alignment: Alignment.centerRight,
          scale: 1.3,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Switch(
                value: _checked,
                onChanged: (checked) {
                  setTemplateChecked(checked);
                  setState(() => _checked = checked);
                } ,
              );
            } 
          )
        ),
      ],
    );
  }
}
