import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewDateTextFieldController extends TextEditingController {
  DateTime initialValue;
  DateTime startValue;
  DateTime endValue;

  NewDateTextFieldController(
      {@required this.initialValue,
      @required this.startValue,
      @required this.endValue})
      : super(text: DateFormat("dd.MM.yyyy").format(initialValue));

  Future selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: initialValue,
      firstDate: startValue,
      lastDate: endValue,
    );
    if (picked != null) initialValue = picked;
    return picked;
  }
}
