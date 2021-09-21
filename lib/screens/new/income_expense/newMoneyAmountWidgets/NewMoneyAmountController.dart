import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_ez_finance/models/Account.dart';
import 'package:project_ez_finance/models/currencies.dart';
import 'package:project_ez_finance/screens/new/income_expense/newMoneyAmountWidgets/NewMoneyAmountFormatter.dart';


class NewMoneyAmountController extends TextEditingController {
  
  static NewMoneyAmountController? instance;
  String? decimalSeparator;
  String? thousandSeparator;
  String? symbol;
  bool? symbolOnLeft;
  int? precision;
  String? initialString;
  bool? spaceBetweenAmountAndSymbol;
  bool isExpense = true;
  void Function(int)? updateFontSize;
  void Function(bool)? setSign;

  NewMoneyAmountController._internal();

  factory NewMoneyAmountController({String? initialString}) {
    instance ??= NewMoneyAmountController._internal();
    if (initialString != null) instance?.initialString = initialString;
    return instance!;
  } 

  TextInputFormatter setupController(
    Account account, 
    double? initialAmount
    ) {
    NewMoneyAmountController();
    Map<String, dynamic> currencyMap = currencies[account.currencyCode]!;
    symbol = currencyMap["symbol"];
    precision = currencyMap["decimal_digits"];
    decimalSeparator = currencyMap["decimal_separator"];
    thousandSeparator = currencyMap["thousands_separator"];
    spaceBetweenAmountAndSymbol = 
      currencyMap["space_between_amount_and_symbol"];
    symbolOnLeft = currencyMap["symbol_on_left"];

    buildInitialText(initialAmount);
    return RightSpaceFormatter(
      decimalSeparator: decimalSeparator!,
      symbol: symbol,
      thousandSeparator: thousandSeparator,
      precision: precision!,
    );
  }

  void buildInitialText(double? initialAmount) {
    if (initialAmount == null) {
      this.text = "0$decimalSeparator${"0" * precision!}";
    }
    else {
      String text = initialAmount.toString().replaceAll(".", decimalSeparator!);
      int precisionDifference = precision! - text.split(decimalSeparator!)[1].length;
      if (precisionDifference > 0) {
        text = text + "0" * precisionDifference;
      } else if (precisionDifference < 0) {
        text = "0$decimalSeparator${"0" * precision!}";
      }
      this.text = text;
      updateThousandseparator(-1);
    }
    this.selection = TextSelection(baseOffset: 0, extentOffset: 0);
    updateFontSize!(this.text.length + this.symbol!.length + 1);
  }

  void press(String key) {
    String oldText = this.text;
    buildText(key);
    if (oldText.length != this.text.length) updateThousandseparator(oldText.length);
    updateFontSize!(this.text.length + this.symbol!.length + 1);
  }

  void buildText(String key) {
    final int baseOffset = this.selection.baseOffset;
    final int extentOffset = this.selection.extentOffset;
    final String currentText = this.text;
    final int separatorIndex = currentText.indexOf(decimalSeparator!);

    // If the baseOffset and extentOffset are not equal, the text is selected.
    // Multiple digit replacement is not allowed until now.
    if (baseOffset != extentOffset) return;

    if (key == "+ / -") {
      setSign!(!isExpense);
      return;
    }

    if (key == "Backspace") {

      // If the cursor is on the very left side, ignore press
      if (baseOffset == 0) return;

      // If the fraction digits are edited, replace them with 0.
      if (baseOffset > separatorIndex + 1 || baseOffset == 1 && separatorIndex == 1) {
        this.text = currentText.substring(0, baseOffset - 1) + "0" + currentText.substring(baseOffset);
      }
      else if (baseOffset < separatorIndex + 1) {
        this.text = currentText.substring(0, baseOffset - 1) + currentText.substring(baseOffset);
      }
      this.selection = TextSelection(baseOffset: baseOffset - 1, extentOffset: baseOffset - 1);
      return;
    }

    if (baseOffset == currentText.length) return;

    if (key != decimalSeparator) {

      if (currentText.length > 14) return;

      if (currentText.characters.toList()[baseOffset] == decimalSeparator) {
          if (currentText.startsWith("0") && baseOffset == 1) {
            this.text = key + currentText.substring(1);
            this.selection = TextSelection(baseOffset: baseOffset, extentOffset: baseOffset);
            return;
          }
          else {
            this.text = currentText.substring(0, baseOffset) + key + this.text.substring(baseOffset);
          }
      }
      else {
        this.text = currentText.replaceRange(baseOffset, baseOffset + 1, key);
      }
      this.selection = TextSelection(baseOffset: baseOffset + 1, extentOffset: baseOffset + 1);
    }
    else {
      this.selection = TextSelection(baseOffset: separatorIndex + 1, extentOffset: separatorIndex + 1);
      return;
    }
  }

  void updateThousandseparator(int oldLength) {
    List<String> numberParts = this.text.split(decimalSeparator!).toList();
    if (numberParts[0].length > 3) {
      int baseOffset = this.selection.baseOffset;
      String wholeAmount = numberParts[0];
      String cleanWholeAmount = wholeAmount.replaceAll(thousandSeparator!, "");

      List<String?> digits =
          cleanWholeAmount.split("").reversed.toList(growable: true);
      for (int i = 3; i < digits.length; i += 4)
        digits.insert(i, thousandSeparator);
      this.text = digits.reversed.join("") + decimalSeparator! + numberParts[1];

      int offset;
      if (oldLength < this.text.length && cleanWholeAmount.length % 3 == 1) {
        offset = baseOffset + 1;
      }
      else if (oldLength > this.text.length && cleanWholeAmount.length % 3 == 0) {
        offset = baseOffset - 1;
      }
      else {
        offset = baseOffset;
      }
      this.selection = TextSelection(baseOffset: offset, extentOffset: offset);
    }
  }

  double getAmount() {
    return double.parse(this.text.replaceAll(thousandSeparator!,"").replaceAll(decimalSeparator!, "."));
  }

  String getAmountString() {
    String space = spaceBetweenAmountAndSymbol! ? " " : "";
    return symbolOnLeft! ? 
      symbol! + space + this.text : 
      this.text + space + symbol!;
  }
}
