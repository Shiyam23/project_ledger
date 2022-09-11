import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_ez_finance/blocs/bloc/bloc.dart';
import 'package:project_ez_finance/blocs/bloc/transactionDetails/cubit/transactiondetails_cubit.dart';
import 'package:project_ez_finance/components/Keyboard.dart';
import 'package:project_ez_finance/models/Category.dart';
import 'package:project_ez_finance/models/Transaction.dart';
import 'package:project_ez_finance/models/Account.dart';
import 'package:project_ez_finance/models/Repetition.dart';
import 'package:project_ez_finance/screens/new/income_expense/newMoneyAmountWidgets/NewMoneyAmountController.dart';
import 'package:project_ez_finance/services/HiveDatabase.dart';
import '../../components/dialogs/ResponseDialog.dart';
import './income_expense/newTextFieldController/NewAccountTextFieldController.dart';
import './income_expense/NewCategoryIcon.dart';
import './income_expense/NewBottomButtons.dart';
import './income_expense/NewSaveAsTemplate.dart';
import './income_expense/NewTextField.dart';
import './income_expense/./newMoneyAmountWidgets/NewMoneyAmount.dart';
import 'income_expense/newTextFieldController/NewRepetitionDialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewTransactionScreen extends StatefulWidget {
  
  _NewTransactionScreenState createState() => _NewTransactionScreenState();
}

class _NewTransactionScreenState extends State<NewTransactionScreen>{
  
  bool _templateChecked = false;
  List<Account>? allAccounts;
  Account? mainAccount;
  NewMoneyAmountController _amountController = NewMoneyAmountController.instance;
  TextEditingController? _titleController;
  TransactionDetails? previousDetails;

  late NewMoneyAmount moneyField;
  final _database = HiveDatabase();
  late Future<List<Account>> futureAllAccounts;

  @override
  void initState() {
   TransactionDetailsCubit cubit = TransactionDetailsCubit.of(context);
    cubit.projectDetails(cubit.state.reset(
      name: true,
      repetition: true,
      isExpense: true,
      category: true,
      amount: true,
    ));
    futureAllAccounts = _database.getAllAccounts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      child: Column(
        children: <Widget>[
          NewMoneyAmount(),
          Transform.translate(
            offset: Offset(0,- MediaQuery.of(context).size.width/12,),
            child: NewCategoryIcon(
              onSelect: (category) => setCategory(context, category)
            ),
          ),
          NewTitleTextField(
            setTitleController: (controller) => _titleController = controller,
          ),
          SizedBox(height: MediaQuery.of(context).size.height/40),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NewDateField(
                  onTap: () => selectDate(context)
                ),
                const Spacer(),
                FutureBuilder(
                  future: futureAllAccounts,
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
          SizedBox(height: MediaQuery.of(context).size.height/40),
          NewRepetitionField(
            onTap: () => selectRepetition(context)
          ),
          SizedBox(height: MediaQuery.of(context).size.height/40),
          NewSaveAsTemplate(
            (bool checked) => _templateChecked = checked, 
            _templateChecked),
          SizedBox(height: MediaQuery.of(context).size.height/40),
          NewBottonButtons(
            onSave: () => saveTransaction(context), 
            onReset: () => resetInput(context)),
        ],
      ),
    );
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
      amount: _amountController.getAmount()
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
      amount: _amountController.getAmount()
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
        amount: _amountController.getAmount()
      );
      TransactionDetailsCubit.of(context).projectDetails(details);
    }
  }

  void saveTransaction(BuildContext context) {
    TransactionDetails details = TransactionDetailsCubit.of(context).state;
    if (_titleController?.text == null || _titleController?.text == "") {
      _showError(context, NewTransactionError.NoName);
      return;
    }
    if (details.category == null) {
      _showError(context, NewTransactionError.NoCategory);
      return;
    }
    if (details.date == null) {
      _showError(context, NewTransactionError.NoDate);
      return;
    }
    if (details.account == null) {
      _showError(context, NewTransactionError.NoAccount);
      return;
    }
    if (details.repetition == null) {
      _showError(context, NewTransactionError.GeneralError);
      return;
    }
    Transaction transaction = Transaction(
      addDateTime: DateTime.now(),
      account: details.account!,
      amount: _amountController.getAmount(),
      amountString: _amountController.getAmountString(),
      category: details.category!,
      isExpense: _amountController.isExpense,
      name: _titleController!.text,
      repetition: details.repetition!,
      date: details.date!
    );
    BlocProvider.of<TransactionBloc>(context).add(AddTransaction(
        transaction, 
        _templateChecked
      ));
    showDialog(
      context: context, 
      builder: (context) => ResponseDialog(
        description: AppLocalizations.of(context)!.transaction_added, 
        response: Response.Success
      )
    );
    context.read<AccountChangeNotifier>().notify();
    this.resetInput(context);
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
      name: "",
      date : DateTime.now(),
      repetition : Repetition.none,
      isExpense: true
    );
    _amountController.buildInitialText(null);
    TransactionDetailsCubit.of(context).projectDetails(details);
  }
  
  void setCategory(BuildContext context, Category? category) {
    FocusScope.of(context).unfocus();
    TransactionDetails details = TransactionDetailsCubit.of(context).state;
    details = details.copyWith(
      category: category,
      name: _titleController!.text,
      amount: _amountController.getAmount()
    ); 
    BlocProvider.of<TransactionDetailsCubit>(context).projectDetails(details);
  }

  void _showError(BuildContext context, NewTransactionError error) {
    String title;
    switch (error) {
      case NewTransactionError.NoName:
        title = AppLocalizations.of(context)!.transaction_noname;
        break;
      case NewTransactionError.NoCategory:
        title = AppLocalizations.of(context)!.transaction_nocategory;
        break;
      case NewTransactionError.NoDate:
        title = AppLocalizations.of(context)!.transaction_nodate;
        break;
      case NewTransactionError.NoAccount:
        title = AppLocalizations.of(context)!.transaction_noaccount;
        break;
      case NewTransactionError.GeneralError:
        title = AppLocalizations.of(context)!.transaction_general_error;
        break;
    }
    showDialog(
      context: context, 
      builder: (context) => ResponseDialog(
        description: title, 
        response: Response.Error
      )
    );
  }  
}



enum NewTransactionError {
  NoName,
  NoCategory,
  NoDate,
  NoAccount,
  GeneralError
}