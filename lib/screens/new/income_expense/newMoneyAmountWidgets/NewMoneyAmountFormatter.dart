import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class FormatHelper {
  String? thousandSeparator;
  String? decimalSeparator;

  FormatHelper({this.thousandSeparator, this.decimalSeparator});

  bool isNumeric(String str) {
    return double.tryParse(str) != null;
  }

  String addThousandsPoint(String number) {
    List<String> numberParts = number.split(",").toList();

    String wholeAmount = numberParts[0];
    String cleanWholeAmount = wholeAmount.replaceAll(thousandSeparator!, "");

    List<String?> digits =
        cleanWholeAmount.split("").reversed.toList(growable: true);
    for (int i = 3; i < digits.length; i += 4)
      digits.insert(i, thousandSeparator);
    return digits.reversed.join("") + decimalSeparator! + numberParts[1];
  }

  int count(String string, String symbol) {
    return string.split("").where((subString) => subString == symbol).length;
  }
}

class RightSpaceFormatter extends TextInputFormatter {
  final String decimalSeparator;
  final String? thousandSeparator;
  final int precision;
  final FormatHelper helper;
  final String? symbol;

  final RegExp zeroSwapper;
  final RegExp zeroDeleter;
  final RegExp decimalSwapper;
  final RegExp inputDecimalSwapper;
  final RegExp zeroGenerator;

  RightSpaceFormatter({
    required this.decimalSeparator,
    required this.thousandSeparator,
    required this.precision,
    required this.symbol,
  }) 
  : helper = new FormatHelper(
      decimalSeparator: decimalSeparator,
      thousandSeparator: thousandSeparator
    ),
    zeroSwapper = RegExp(r"^0" + "$decimalSeparator" + r"\d" * precision + " $symbol"),
    zeroDeleter = RegExp(r"^0\d" "$decimalSeparator" + r"\d" * precision + " $symbol"),
    decimalSwapper = RegExp(decimalSeparator + r"\d" * (precision + 1) + " $symbol"),
    inputDecimalSwapper = RegExp(decimalSeparator + r"\d" * (precision - 1) + " $symbol"),
    zeroGenerator = RegExp("^$decimalSeparator" + r"\d" * precision + " $symbol");

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;
    String oldText = oldValue.text;

    // Generate zero if there is no integer before separator -----> This takes too much performance
    if (zeroGenerator.hasMatch(newText)) {
      return TextEditingValue(
          text: "0" + newText,
          selection: TextSelection(baseOffset: 0, extentOffset: 0));
    }

    if (newText.startsWith(thousandSeparator!) 
      || newText.startsWith(decimalSeparator)) return oldValue;

    // if cursor left of zero, swap it with input number
    if (oldValue.selection.baseOffset == 0 && zeroSwapper.hasMatch(oldText)) {
      return TextEditingValue(
          text: newText[0] + newText.substring(2),
          selection: TextSelection(baseOffset: 1, extentOffset: 1));
    }

    //  delete not-allowed thousandOperators
    if (!newText.contains(thousandSeparator! + decimalSeparator) &&
        helper.count(newText, thousandSeparator!) !=
            helper.count(oldText, thousandSeparator!)) {
      return oldValue;
    }


    // Switch to decimals
    if (newText.contains(decimalSeparator * 2)) {
      return TextEditingValue(
        text: oldText,
        selection: TextSelection(
          baseOffset: oldText.indexOf(decimalSeparator) + 1,
          extentOffset: oldText.indexOf(decimalSeparator) + 1
        )
      );
    }

    // generate missing separator and switch back to integer
    if (!newText.contains(decimalSeparator)) {
      return TextEditingValue(
        text: oldText,
        selection: TextSelection(
            baseOffset: oldText.indexOf(decimalSeparator),
            extentOffset: oldText.indexOf(decimalSeparator)),
      );
    }

    // Delete leading zero, if there's already one
    if (zeroDeleter.hasMatch(newText)) {
      int cursorPos = newValue.selection.baseOffset;

      return TextEditingValue(
          text: newText.substring(1),
          selection: TextSelection(
              baseOffset: cursorPos - 1, extentOffset: cursorPos - 1));
    }

    // if there are 3 decimals, delete the last one
    if (newValue.selection.baseOffset >
        newText.indexOf(decimalSeparator) + precision + 1) {
      return oldValue;
    }

    // swap decimal digit (0) with input decimal digit
    if (decimalSwapper.hasMatch(newText)) {
      return TextEditingValue(
          text: newText.substring(0, newValue.selection.baseOffset) +
              newText.substring(newValue.selection.baseOffset + 1),
          selection: newValue.selection);
    }

    // swap input decimial digit with 0 if deleted
    if (inputDecimalSwapper.hasMatch(newText)) {
      return TextEditingValue(
          text: newText.substring(0, newValue.selection.baseOffset) +
              "0" +
              newText.substring(newValue.selection.baseOffset),
          selection: newValue.selection);
    }

    if (helper.count(newText, decimalSeparator) != 1) return oldValue;

    if (newText.length > 20 || !newText.endsWith(" " + symbol!))
      return oldValue;

    // Update thousands separator
    String withThousandPoints = helper.addThousandsPoint(newText);

    if (withThousandPoints != newText) {
      withThousandPoints = helper.addThousandsPoint(newText);
      int initialOffset =
          oldText.indexOf(decimalSeparator) - oldValue.selection.baseOffset;
      return TextEditingValue(
          text: withThousandPoints,
          selection: TextSelection(
              baseOffset: withThousandPoints.indexOf(decimalSeparator) -
                  initialOffset,
              extentOffset: withThousandPoints.indexOf(decimalSeparator) -
                  initialOffset));
    }

    return newValue;
  }
}
