import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class NewMoneyAmountController extends TextEditingController {
  final String decimalSeparator;
  final String thousandSeparator;
  final String symbol;
  final bool symbolIsRight;
  final int precision;
  final double initialValue;
  String? lastValue;

  NewMoneyAmountController(
      {this.initialValue = 0.0,
      this.decimalSeparator = ',',
      this.thousandSeparator = '.',
      this.symbol = '',
      this.symbolIsRight = true,
      this.precision = 2}) {
    if (valueHasExactFractionDigits(initialValue, precision))
      throw ArgumentError(
          "Initial value fraction digits not equal to precision");

    this.text = "0" + decimalSeparator + "00 " + symbol;
    this.selection = TextSelection.fromPosition(TextPosition(offset: 0));
  }

  bool valueHasExactFractionDigits(double value, int digits) {
    return value.toStringAsFixed(digits) == value.toString();
  }
}
