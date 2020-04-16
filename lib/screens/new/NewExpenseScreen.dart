import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_ez_finance/blocs/bloc/bloc.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIcon.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIconData.dart';
import 'package:project_ez_finance/models/Category.dart';
import 'package:project_ez_finance/models/Transaction.dart';
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

class NewExpenseScreen extends StatefulWidget {
  @override
  _NewExpenseScreenState createState() => _NewExpenseScreenState();
}

class _NewExpenseScreenState extends State<NewExpenseScreen> {
  // Selections and Settings
  final Transaction transaction = Transaction();
  static String currency = " €";
  static DateTime _selectedDate = DateTime.now();
  Account _selectedAccount;
  Repetition _selectedRepetition;
  CalenderUnit chosenTimeUnit = CalenderUnit.monthly;

  //Controllers
  NewAccountTextFieldController accountController;
  NewDateTextFieldController dateController;
  NewRepetitionTextFieldController repeatController;

  //Input fields
  NewTitleTextField titleField = NewTitleTextField();
  NewMoneyAmount moneyField;

  _NewExpenseScreenState() {
    dateController = NewDateTextFieldController(
        initialValue: _selectedDate,
        startValue: _selectedDate.subtract(Duration(days: 365 * 30)),
        endValue: _selectedDate.add(Duration(days: 365 * 30)));
    accountController = NewAccountTextFieldController();
    repeatController =
        NewRepetitionTextFieldController(initialRepetition: Repetition.none);
    moneyField = NewMoneyAmount(transaction: transaction, currency: currency);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Spacer(),
        moneyField,
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
                    child: titleField)
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
        NewBottonButtons(onSave: saveTransaction, onReset: resetInput),
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

  void saveTransaction() {
    transaction.date = _selectedDate;
    transaction.account = Account(
        icon: CategoryIcon(
      iconData: CategoryIconData(
          backgroundColorInt: Theme.of(context).backgroundColor.value,
          iconName: "suitcaseRolling"),
    ));
    transaction.isExpense = true;
    transaction.repetition = _selectedRepetition;
    transaction.category = Category(
        name: "Testkategorie",
        icon: CategoryIcon(
          iconData: CategoryIconData(
              backgroundColorInt: Theme.of(context).backgroundColor.value,
              iconName: "suitcaseRolling"),
        ));
    transaction.name = titleField.getText();

    BlocProvider.of<DatabaseBloc>(context)
        .dispatch(AddTransaction(transaction));
  }

  void resetInput() {}
}
