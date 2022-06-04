import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_ez_finance/blocs/bloc/bloc.dart';
import 'package:project_ez_finance/blocs/bloc/transactionDetails/cubit/transactiondetails_cubit.dart';
import 'package:project_ez_finance/components/Keyboard.dart';
import 'package:project_ez_finance/models/Category.dart';
import 'package:project_ez_finance/models/Transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:project_ez_finance/models/Account.dart';
import 'package:project_ez_finance/models/Repetition.dart';
import 'package:project_ez_finance/screens/new/income_expense/newMoneyAmountWidgets/NewMoneyAmountController.dart';
import 'package:project_ez_finance/services/HiveDatabase.dart';
import './income_expense/newTextFieldController/NewAccountTextFieldController.dart';
import './income_expense/NewCategoryIcon.dart';
import './income_expense/NewBottomButtons.dart';
import './income_expense/NewSaveAsTemplate.dart';
import './income_expense/NewTextField.dart';
import './income_expense/./newMoneyAmountWidgets/NewMoneyAmount.dart';
import 'income_expense/newTextFieldController/NewRepetitionDialog.dart';

class NewTransactionScreen extends StatefulWidget {
  
  _NewTransactionScreenState createState() => _NewTransactionScreenState();
}

class _NewTransactionScreenState extends State<NewTransactionScreen>{
  
  bool _templateChecked = false;
  

  List<Account>? allAccounts;
  Account? mainAccount;
  NewMoneyAmountController? _amountController;
  TextEditingController? _titleController;
  TransactionDetails? previousDetails;

  late NewMoneyAmount moneyField;
  final _database = HiveDatabase();

  @override
  void initState() {
   TransactionDetailsCubit cubit = TransactionDetailsCubit.of(context);
    cubit.emit(cubit.state.reset(
      name: true,
      repetition: true,
      isExpense: true,
      category: true,
      amount: true,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: <Widget>[
        const Spacer(),
        NewMoneyAmount(
          setController: setAmountController,
        ),
        const Spacer(),
        Container(
          alignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width * 0.85,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              NewCategoryIcon(
                onSelect: (category) => setCategory(context, category)
              ),
              Container(
                padding: EdgeInsets.only(left: 20),
                child: NewTitleTextField(
                  setTitleController: (controller) => _titleController = controller,
                )
              )
            ],
          ),
        ),
        const Spacer(),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * 0.85,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NewDateField(
                onTap: () => selectDate(context)
              ),
              const Spacer(),
              FutureBuilder(
                future: _database.getAllAccounts(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    refreshAccounts(context, snapshot.data as List<Account>);
                  } 
                  return NewAccountField(
                    onTap: () => selectAccount(context),
                  );
                },
              ),
            ],
          ),
        ),
        const Spacer(),
        NewRepetitionField(
          onTap: () => selectRepetition(context)
        ),
        const Spacer(),
        Container(
          alignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width * 0.85,
          child: NewSaveAsTemplate(
            (bool checked) => _templateChecked = checked, 
            _templateChecked)),
        const Spacer(flex: 2),
        NewBottonButtons(
          onSave: () => saveTransaction(context), 
          onReset: () => resetInput(context)),
        const Spacer(flex: 2),
      ],
    );
  }

  void setAmountController(NewMoneyAmountController controller) {
    _amountController = controller;
  }

  void selectDate(BuildContext context) async {
    TransactionDetails details = TransactionDetailsCubit.of(context).state;
    FocusScope.of(context).unfocus();
    KeyboardWidget.of(context)?.triggerKeyboard(false);
    DateTime initialDate = details.date ?? DateTime.now();
    DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: initialDate.subtract(Duration(days: 365)),
      lastDate: initialDate.add(Duration(days: 365)),
    );
    details = details.copyWith(
      date: pickedDateTime ?? details.date,
      name: _titleController!.text,
      amount: _amountController!.getAmount()
    );
    TransactionDetailsCubit.of(context).projectDetails(details);
  }

  void selectRepetition(BuildContext context) async {
    TransactionDetails details = TransactionDetailsCubit.of(context).state;
    FocusScope.of(context).unfocus();
    KeyboardWidget.of(context)?.triggerKeyboard(false);
    NewRepetitionDialog dialog = NewRepetitionDialog(
      initialRepetition: details.repetition ?? Repetition.none);
    Repetition? selectedRepetition = await dialog.chooseRepetition(context);
    details = details.copyWith(
      repetition: selectedRepetition ?? details.repetition,
      name: _titleController!.text,
      amount: _amountController!.getAmount()
    );
    TransactionDetailsCubit.of(context).projectDetails(details);
  }

  void selectAccount(BuildContext context) async {
    FocusScope.of(context).unfocus();
    KeyboardWidget.of(context)?.triggerKeyboard(false);
    TransactionDetails details = TransactionDetailsCubit.of(context).state;
    Account? account = await NewAccountDialog
        .chooseAccount(context, allAccounts!);
    if (account != details.account) {
      details = details.copyWith(
        account: account,
        name: _titleController!.text,
        amount: _amountController!.getAmount()
      );
      TransactionDetailsCubit.of(context).projectDetails(details);
    }
  }

  void saveTransaction(BuildContext context) {
    TransactionDetails details = TransactionDetailsCubit.of(context).state;

    if (
      _titleController?.text != null &&
      _titleController?.text != "" &&
      details.category != null && 
      details.date != null &&
      details.account != null &&
      details.repetition != null &&
      _amountController != null
      ) 
    {
      Transaction transaction = Transaction(
        addDateTime: DateTime.now(),
        account: details.account!,
        amount: _amountController!.getAmount(),
        amountString: _amountController!.getAmountString(),
        category: details.category,
        isExpense: _amountController!.isExpense,
        name: _titleController!.text,
        repetition: details.repetition!,
        date: details.date!
      );
      BlocProvider.of<TransactionBloc>(context).add(AddTransaction(
          transaction, 
          details.account!,
          _templateChecked
        ));
      this.resetInput(context);
    } 
    else {
      showError(context);
    }
  }

  void refreshAccounts(BuildContext context, List<Account> loadedAccounts) {
    TransactionDetails details = TransactionDetailsCubit.of(context).state;
    allAccounts = loadedAccounts;
    if (allAccounts != null && mainAccount == null) {
      mainAccount ??= allAccounts!.firstWhere((account) => account.selected);
      details = details.copyWith(
        account : mainAccount,
      );
      previousDetails = details;
      TransactionDetailsCubit.of(context).projectDetails(details);
    }
  }

  

  void resetInput(BuildContext context) {

    TransactionDetails details = TransactionDetailsCubit.of(context).state;
    details = TransactionDetails(
      account : mainAccount,
      category : null,
      name: null,
      date : DateTime.now(),
      repetition : Repetition.none,
      isExpense: true
    );
    _amountController!.buildInitialText(null);
    TransactionDetailsCubit.of(context).projectDetails(details);
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
      message: 'Account and Category must be selected',
    ).show(context);
  }
  
  void setCategory(BuildContext context, Category? category) {
    FocusScope.of(context).unfocus();
    TransactionDetails details = TransactionDetailsCubit.of(context).state;
    details = details.copyWith(
      category: category,
      name: _titleController!.text,
      amount: _amountController!.getAmount()
    ); 
    BlocProvider.of<TransactionDetailsCubit>(context).emit(details);
  }  
}
