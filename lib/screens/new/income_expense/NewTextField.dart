import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class NewTextField extends StatefulWidget {
  final double widthRatio;
  final String labelText;
  final void Function()? onTap;
  final TextEditingController? controller;
  final double fontSize;
  final bool enabled;

  NewTextField(
      {this.widthRatio = 0.85,
      required this.labelText,
      this.enabled = true,
      this.fontSize = 20,
      this.controller,
      this.onTap});

  @override
  _NewTextFieldState createState() => _NewTextFieldState();
}

class _NewTextFieldState extends State<NewTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * widget.widthRatio,
      child: TextFormField(
        enableInteractiveSelection: false,
        onTap: widget.onTap,
        readOnly: true,
        enabled: widget.enabled,
        controller: widget.controller,
        style: TextStyle(
          height: 1.5,
            fontSize: widget.fontSize,
            color: Theme.of(context).colorScheme.primary),
        decoration: InputDecoration(
          filled: true,
          contentPadding: const EdgeInsets.all(5),
          enabled: widget.enabled,
          labelText: widget.labelText,
          labelStyle: TextStyle(fontSize: 15),
        ),
      ),
    );
  }
}
