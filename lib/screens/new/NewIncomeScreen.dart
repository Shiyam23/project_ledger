import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:project_ez_finance/models/Account.dart';
import 'package:project_ez_finance/models/Repetition.dart';
import './income_expense/newTextFieldController/NewAccountTextFieldController.dart';
import './income_expense/newTextFieldController/NewDateTextFieldController.dart';
import './income_expense/NewCategoryIcon.dart';
import './income_expense/NewBottomButtons.dart';
import './income_expense/NewSaveAsTemplate.dart';
import './income_expense/NewTextField.dart';
import './income_expense/NewTitleTextField.dart';
import './income_expense/./newMoneyAmountWidgets/NewMoneyAmount.dart';
import './income_expense/newTextFieldController/NewRepetitionTextFieldController.dart';

class NewIncomeScreen extends StatefulWidget {
  @override
  _NewIncomeScreenState createState() => _NewIncomeScreenState();
}

class _NewIncomeScreenState extends State<NewIncomeScreen> {
  final String currency = " €";
  DateTime _selectedDate = DateTime.now();
  Account _selectedAccount;
  Repetition _selectedRepetition;
  NewAccountTextFieldController accountController;
  NewDateTextFieldController dateController;
  CalenderUnit chosenTimeUnit = CalenderUnit.monthly;

  NewRepetitionTextFieldController repeatController;

  _NewIncomeScreenState() {
    dateController = NewDateTextFieldController(
        initialValue: _selectedDate,
        startValue: _selectedDate.subtract(Duration(days: 365 * 30)),
        endValue: _selectedDate.add(Duration(days: 365 * 30)));
    accountController = NewAccountTextFieldController();

    repeatController =
        NewRepetitionTextFieldController(initialRepetition: Repetition.none);
  }

  //int amount;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Spacer(),
        NewMoneyAmount(currency: currency),
        Spacer(),
        Container(
          alignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width * 0.75,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                NewCategoryIcon(),
                Container(
                    padding: EdgeInsets.only(left: 20),
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: NewTitleTextField())
              ],
            ),
          ),
        ),
        Spacer(),
        NewTextField(
            labelText: "Datum",
            controller: dateController,
            onTap: () async {
              DateTime temp = await (dateController).selectDate(context);
              if (temp != null) {
                setState(() => dateController.text =
                    DateFormat("dd.MM.yyyy").format(temp).toString());
                _selectedDate = temp;
              }
            }),
        Spacer(),
        NewTextField(
            labelText: "Konto",
            controller: accountController,
            onTap: () async {
              Account temp = await accountController.chooseAccount(context);
              if (temp != null) {
                setState(() => accountController.text = temp.toString());
                _selectedAccount = temp;
              }
            }),
        Spacer(),
        NewTextField(
            labelText: "Dauerauftrag",
            controller: repeatController,
            onTap: () async {
              Repetition temp =
                  await repeatController.chooseRepetition(context);
              if (temp != null) {
                setState(() => repeatController.text = temp.toString());
                _selectedRepetition = temp;
              }
            }),
        Spacer(),
        NewSaveAsTemplate(),
        Spacer(
          flex: 2,
        ),
        NewBottonButtons(),
        Spacer(flex: 2),
      ],
    );
  }

  @override
  void dispose() {
    dateController.dispose();
    accountController.dispose();
    repeatController.dispose();
    super.dispose();
  }
}
