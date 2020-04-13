import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class NewTitleTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: TextFormField(
        style: TextStyle(
            fontSize: 20, color: Theme.of(context).colorScheme.primary),
        cursorColor: Theme.of(context).colorScheme.primary,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(5),
            labelText: "Name",
            labelStyle: TextStyle(fontSize: 15)),
      ),
    );
  }
}
