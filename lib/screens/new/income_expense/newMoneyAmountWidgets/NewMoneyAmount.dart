import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'NewMoneyAmountController.dart';
import 'NewMoneyAmountFormatter.dart';

class NewMoneyAmount extends StatefulWidget {
  const NewMoneyAmount({
    Key key,
    @required this.currency,
  }) : super(key: key);

  final String currency;

  @override
  _NewMoneyAmountState createState() => _NewMoneyAmountState();
}

class _NewMoneyAmountState extends State<NewMoneyAmount> {
  double fontSizeFactor = 0.15;
  NewMoneyAmountController controller;

  int precision = 2;
  String symbol = "€";
  String decimalSeparator = ",";
  String thousandSeparator = ".";

  @override
  initState() {
    controller = NewMoneyAmountController(
        symbol: symbol,
        decimalSeparator: decimalSeparator,
        thousandSeparator: thousandSeparator,
        precision: precision);
    super.initState();
  }

  void updateFontSize(int textLength) {
    if (textLength > 18) {
      this.fontSizeFactor = 0.0825;
      return;
    }
    if (textLength > 14) {
      this.fontSizeFactor = 0.10;
      return;
    }
    if (textLength > 11) {
      this.fontSizeFactor = 0.125;
      return;
    } else {
      this.fontSizeFactor = 0.15;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 7,
      alignment: Alignment.center,
      child: TextField(
        inputFormatters: [
          NewMoneyAmountFormatter(
              decimalSeparator: decimalSeparator,
              thousandSeparator: thousandSeparator,
              precision: precision,
              symbol: symbol),
        ],
        onChanged: (text) => setState(() => updateFontSize(text.length)),
        controller: controller,
        toolbarOptions: ToolbarOptions(
            copy: true, cut: false, paste: false, selectAll: true),
        keyboardType: TextInputType.numberWithOptions(
          decimal: true,
          signed: false,
        ),
        decoration: InputDecoration(border: InputBorder.none),
        textDirection: TextDirection.ltr,
        cursorColor: Theme.of(context).colorScheme.primary,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: MediaQuery.of(context).size.width * fontSizeFactor,
            color: Theme.of(context).colorScheme.primary),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
