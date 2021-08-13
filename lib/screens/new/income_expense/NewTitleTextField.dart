import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class NewTitleTextField extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.65,
      child: TextFormField(
        controller: controller,
        style: TextStyle(
          height: 1.5,
            fontSize: 20, color: Theme.of(context).colorScheme.primary),
        cursorColor: Theme.of(context).colorScheme.primary,
        decoration: InputDecoration(
          filled: true,
            contentPadding: EdgeInsets.all(5),
            labelText: "Name",
            labelStyle: TextStyle(fontSize: 15)),
      ),
    );
  }

  String getText() {
    return controller.text;
  }
}
