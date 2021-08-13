import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class NewSaveAsTemplate extends StatefulWidget {
  @override
  _NewSaveAsTemplateState createState() => _NewSaveAsTemplateState();
}

class _NewSaveAsTemplateState extends State<NewSaveAsTemplate> {
  bool? _checked = false;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Checkbox(
            value: _checked,
            checkColor: Colors.white,
            activeColor: Theme.of(context).colorScheme.primary,
            onChanged: (checked) => setState(() => _checked = checked),
          ),
          Text("Als Vorlage speichern",
              textAlign: TextAlign.left, style: TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}
