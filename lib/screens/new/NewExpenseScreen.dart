import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_ez_finance/blocs/bloc/account_bloc.dart';
import 'package:project_ez_finance/blocs/bloc/account_event.dart';
import 'package:project_ez_finance/blocs/bloc/account_state.dart';
import 'package:project_ez_finance/blocs/bloc/bloc.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIcon.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIconData.dart';
import 'package:project_ez_finance/models/Category.dart';
import 'package:project_ez_finance/models/Transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:project_ez_finance/models/Account.dart';
import 'package:project_ez_finance/models/Repetition.dart';
import 'package:project_ez_finance/screens/new/income_expense/newMoneyAmountWidgets/NewMoneyAmountController.dart';
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
  static String currency = "€";
  static DateTime _selectedDate = DateTime.now();
  Account? _selectedAccount;
  Repetition? _selectedRepetition;
  CalenderUnit? chosenTimeUnit = CalenderUnit.monthly;

  //Controllers
  NewAccountTextFieldController? accountController;
  NewDateTextFieldController? dateController;
  NewRepetitionTextFieldController? repeatController;
  NewMoneyAmountController? moneyAmountController;

  //Accounts
  List<Account>? allAccounts;
  String? mainAccountName;

  //Input fields
  NewTitleTextField titleField = NewTitleTextField();
  late NewMoneyAmount moneyField;

  _NewExpenseScreenState() {
    dateController = NewDateTextFieldController(
        initialValue: _selectedDate,
        startValue: _selectedDate.subtract(Duration(days: 365 * 30)),
        endValue: _selectedDate.add(Duration(days: 365 * 30)));
    accountController = NewAccountTextFieldController();
    repeatController =
        NewRepetitionTextFieldController(initialRepetition: Repetition.none);
    moneyField = NewMoneyAmount(currency: currency);
    moneyAmountController = moneyField.controller;
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AccountBloc>(context).add(GetAccount());
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
              DateTime? temp = await (dateController!.selectDate(context));
              if (temp != null) {
                setState(() => dateController!.text =
                    DateFormat("dd.MM.yyyy").format(temp).toString());
                _selectedDate = temp;
              }
            }),
        Spacer(),
        BlocListener<AccountBloc, AccountState>(
          listener: (context, state) {
            if (state is AccountLoaded) {
              allAccounts = state.accountList;
              if (allAccounts == null) return;
              _selectedAccount =
                  allAccounts!.isNotEmpty ? allAccounts![0] : null;
              mainAccountName = _selectedAccount?.name;
            }
          },
          child: NewTextField(
              labelText: "Konto",
              controller: accountController,
              onTap: () async {
                if (mainAccountName == null) return;
                Account? temp = await accountController!
                    .chooseAccount(context, mainAccountName!, allAccounts!);
                if (temp != null) {
                  setState(() => accountController!.text = temp.toString());
                  _selectedAccount = temp;
                }
              }),
        ),
        Spacer(),
        NewTextField(
            labelText: "Dauerauftrag",
            controller: repeatController,
            onTap: () async {
              Repetition? temp =
                  await repeatController!.chooseRepetition(context);
              if (temp != null) {
                setState(() => repeatController!.text = temp.toString());
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
    dateController!.dispose();
    accountController!.dispose();
    repeatController!.dispose();
    super.dispose();
  }

  void saveTransaction() {
    if (_selectedAccount == null) {
      showError(context);
      return;
    }
    Transaction transaction = Transaction(
        addDateTime: DateTime.now(),
        account: _selectedAccount,
        amount: moneyAmountController?.text ?? "0,75 €",
        category: Category(
            name: "Testkategorie",
            icon: CategoryIcon(
              iconData: CategoryIconData(
                  backgroundColorInt: Theme.of(context).backgroundColor.value,
                  iconName: "suitcaseRolling"),
            )),
        isExpense: true,
        name: titleField.getText(),
        repetition: _selectedRepetition,
        date: _selectedDate);
    BlocProvider.of<TransactionBloc>(context)
        .add(AddTransaction(transaction, _selectedAccount!));
    this.resetInput();
  }

  void resetInput() {
    this.moneyAmountController?.text = "0,00 €";
    this.titleField.controller.clear();
    this.accountController?.text = mainAccountName ?? "";
    this._selectedAccount = allAccounts != null ? allAccounts![0] : null;
    this.dateController?.initialValue = DateTime.now();
  }

  Future showError(context) {
    return Flushbar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      icon: Icon(
        Icons.warning,
        size: 28.0,
        color: Colors.red[300],
      ),
      leftBarIndicatorColor: Colors.red[300],
      duration: const Duration(seconds: 3),
      title: 'Invalid Input!',
      message: 'Account must be selected',
    ).show(context);
  }
}
