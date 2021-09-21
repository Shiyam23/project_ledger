import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewDateTextFieldController extends TextEditingController {
  DateTime initialValue;
  DateTime startValue;
  DateTime endValue;

  NewDateTextFieldController(
      {required this.initialValue,
      required this.startValue,
      required this.endValue})
      : super(text: DateFormat("dd.MM.yyyy").format(initialValue));

  Future selectDate(BuildContext context) async {
    
  }
}
