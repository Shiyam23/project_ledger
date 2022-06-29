import 'dart:collection';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_ez_finance/blocs/bloc/transaction/transaction_bloc.dart';
import 'package:project_ez_finance/blocs/bloc/transaction/transaction_event.dart';
import 'package:project_ez_finance/blocs/bloc/transaction/transaction_state.dart';
import 'package:project_ez_finance/components/CategorySelectionSheet.dart';
import 'package:project_ez_finance/components/PieChart.dart';
import 'package:project_ez_finance/components/IconListTile.dart';
import 'package:project_ez_finance/components/TextInputDialog.dart';
import 'package:project_ez_finance/models/Category.dart';
import 'package:project_ez_finance/models/Modes.dart';
import 'package:collection/collection.dart' show ListEquality;
import 'package:project_ez_finance/models/Transaction.dart';
import 'package:project_ez_finance/models/currencies.dart';
import 'package:project_ez_finance/screens/new/NewTransactionScreen.dart';
import 'package:project_ez_finance/screens/new/income_expense/newMoneyAmountWidgets/NewMoneyAmount.dart';
import 'package:project_ez_finance/screens/view/filterbar/ViewBarSection.dart';
import 'dart:math' as math;
import 'package:project_ez_finance/services/HiveDatabase.dart';

class ViewTransactionScreen extends StatefulWidget {
  final Function _eq = const ListEquality().equals;
  final TransactionRequest request = TransactionRequest(
      searchText: null,
      viewMode: ViewMode.List,
      timeMode: TimeMode.Individual,
      sortMode: SortMode.DateAsc,
      dateRange: DateTimeRange(
          start: DateTime(DateTime.now().year, DateTime.now().month),
          end: DateTime(DateTime.now().year, DateTime.now().month + 1)
              .subtract(Duration(microseconds: 1))));
  ViewTransactionScreen({Key? key}) : super(key: key);

  @override
  _ViewScreenState createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewTransactionScreen> with SingleTickerProviderStateMixin{

  late final TransactionBloc? _databaseBloc = BlocProvider.of<TransactionBloc>(context);
  final HashSet<Transaction> _selectedTransactions = HashSet();
  late final Widget topViewBar = ViewFilterBarSection(request: widget.request);
  late final Widget topSelectionBar = ViewSelectionBarSection(
    onDelete: onDelete,
    onDeleteAll: onDeleteAll,
    onEdit: onEdit,
    onReset: onReset,
    selectedTransactionsNotifier: selectedTransactionsNotifier
  );
  late Widget topBar = topViewBar;

  late final AnimationController _animationController = AnimationController(
    duration: Duration(milliseconds: 100),
    vsync: this
  );
  late final Animation rotation = Tween<double>(
    begin: 0,
    end: 0.5 * math.pi
  ).animate(_animationController);

  final ValueNotifier<int> selectedTransactionsNotifier = ValueNotifier<int>(0);
  final HashMap<int, GlobalObjectKey> transactionKeys = new HashMap();

  @override
  void initState() {
    _databaseBloc?.add(GetTransaction(widget.request));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: _animationController,
          child: topBar,
          builder: (context, child) => Transform(
            transform: Matrix4.rotationX(rotation.value),
            alignment: Alignment.center,
            child: topBar
          ),
        ),
        BlocBuilder<TransactionBloc, TransactionState>(
          buildWhen: (previousState, currentState) {
            return !(previousState is TransactionLoaded &&
                    currentState is TransactionLoaded) ||
                !widget._eq(previousState.transactionList,
                    currentState.transactionList);
          },
          builder: (BuildContext context, TransactionState state) {
            if (state is GraphLoaded) {
              return Expanded(
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: PieLabelChart.fromChartInfo(state.chartInfo)
                  ),
                ),
              );
            }
            if (state is TransactionLoaded) {
              return Flexible(
                child: Scrollbar(
                  child: ListView.builder(
                    key: ValueKey(state.transactionList.length),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: state.transactionList.length,
                    physics: BouncingScrollPhysics(),
                    dragStartBehavior: DragStartBehavior.down,
                    itemBuilder: (BuildContext context, int index) {
                      Transaction transaction = state.transactionList[index];
                      GlobalObjectKey key = GlobalObjectKey(transaction);
                      transactionKeys[transaction.hashCode] = key;
                      return Card(
                        elevation: 10.0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: IconListTile(
                          onSelect: () => onTransactionSelect(transaction),
                          onTap: () => onTransactionSelect(transaction),
                          selectable: true,
                          selected: _selectedTransactions.contains(transaction),
                          key: key,
                          tile: transaction,
                        ),
                      );
                    }
                  ),
                ),
              );
            }
            return const Center(child: const CircularProgressIndicator());
          },
        ),
      ],
    );
  }

  void onTransactionSelect(Transaction transaction) async {
    if (_selectedTransactions.contains(transaction)) {
      _selectedTransactions.remove(transaction);
    }
    else {
      _selectedTransactions.add(transaction);
    }
    if (_selectedTransactions.isNotEmpty && topBar is ViewFilterBarSection) {
      _flipToSelectionBar();
    }
    else if (_selectedTransactions.isEmpty && topBar is ViewSelectionBarSection) {
      _flipToViewBar();
    }
    selectedTransactionsNotifier.value = _selectedTransactions.length;
  }

  void onDelete() async {
    _databaseBloc?.add(
      DeleteTransaction(_selectedTransactions.toList())
    );
    _selectedTransactions.forEach((transaction) {
      transactionKeys.remove(GlobalObjectKey(transaction));
    });
    _selectedTransactions.clear();
    _flipToViewBar();
  }

  void onDeleteAll() {
    _databaseBloc?.add(const DeleteAllShownTransactions());
    _selectedTransactions.clear();
    transactionKeys.clear();
    _flipToViewBar();
  }

  void onReset() {
    _selectedTransactions.forEach((transaction) {
      (transactionKeys[transaction.hashCode]?.currentWidget as IconListTile)
      .selectedNotifier?.value = false;
    });
    _selectedTransactions.clear();
    _flipToViewBar();
  }

  void _flipToViewBar() async {
    await _animationController.forward();
    topBar = topViewBar;
    _animationController.reverse();
  }

  void _flipToSelectionBar() async {
    await _animationController.forward();
    topBar = topSelectionBar;
    _animationController.reverse();
  }

  void onEdit() async {
    showModalBottomSheet(context: context, builder: (sheetContext) {
      return SafeArea(
        left: false,
        right: false,
        top: false,
        child: Wrap(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
              title: const Text("Edit name"),
              leading: const Icon(Icons.edit),
              onTap: _onEditName,
            ),
            const Divider(
              thickness: 1,
              height: 1,
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
              title: const Text("Change category"),
              leading: const Icon(Icons.circle),
              onTap: _onEditCategory,
            ),
            const Divider(
              thickness: 1,
              height: 1,
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
              title: const Text("Change date"),
              leading: const Icon(Icons.calendar_today),
              onTap: _onEditDate,
            ),
            const Divider(
              thickness: 1,
              height: 1,
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
              title: const Text("Change amount"),
              leading: const Icon(Icons.money),
              onTap: _onEditAmount,
            ),
          ]
        ),
      );
    });    
  }

  void _onEditName() async {
    Navigator.of(context).pop();
    if (!await _checkForSingleItem()) return;
    Transaction selectedTransaction = _selectedTransactions.first;
    TextEditingController controller = new TextEditingController();
    String oldName = selectedTransaction.name;
    controller.text = oldName;
    controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: oldName.length
    );
    String? newName = await showDialog<String>(
      context: context, 
      builder: (context) => TextInputDialog(
        controller: controller, 
        prefixIcon: Icon(FontAwesomeIcons.pen), 
        title: Text("Enter new name"))
    );
    if (newName != null && newName != "" && newName != oldName) {
      Transaction newTransaction = selectedTransaction.copyWith(
        name: newName,
      );
      _changeTransaction(selectedTransaction, newTransaction);
    }
  }

  void _onEditDate() async {
    Navigator.of(context).pop();
    if (!await _checkForSingleItem()) return;
    Transaction selectedTransaction = _selectedTransactions.first;
    DateTime oldDate = selectedTransaction.date;
    DateTime? newDate = await showDatePicker(
      context: context, 
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365)),
      initialDate: oldDate
    );
    if (newDate != null && newDate != oldDate) {
      Transaction newTransaction = selectedTransaction.copyWith(
        date: newDate,
      );
      _changeTransaction(selectedTransaction, newTransaction);
    }
  }

  void _onEditCategory() async {
    Navigator.of(context).pop();
    if (!await _checkForSingleItem()) return;
    Transaction selectedTransaction = _selectedTransactions.first;
    Category? newCategory = await showCategorySelectionSheet(context);
    if (newCategory != null) {
      Transaction newTransaction = selectedTransaction.copyWith(
      category: newCategory
      );
      _changeTransaction(selectedTransaction, newTransaction);
    }
  }

  void _onEditAmount() async {
    Navigator.of(context).pop();
    if (!await _checkForSingleItem()) return;
    TextEditingController controller = TextEditingController();
    Transaction selectedTransaction = _selectedTransactions.first;
    String? newAmountString = await showDialog<String>(
      context: context,
      builder: (context) => TextInputDialog(
        validator: validateAmount,
        controller: controller,
        prefixIcon: Icon(FontAwesomeIcons.moneyBill),
        title: Text("New amount"),
      )
    );
    bool isExpense = true;
    String currencyCode = HiveDatabase().selectedAccount!.currencyCode;
    if (newAmountString != null) {
      if (newAmountString.startsWith('+')) isExpense = false;
      double newAmount = double.parse(newAmountString.substring(1).trim());
      Transaction newTransaction = selectedTransaction.copyWith(
        isExpense: isExpense,
        amount: newAmount,
        amountString: formatCurrency(currencyCode, newAmount)
      );
      _changeTransaction(selectedTransaction, newTransaction);
    }
  }

  void _changeTransaction(
    Transaction oldTransaction, 
    Transaction newTransaction
  ) async {
    await HiveDatabase().deleteTransactions([oldTransaction]);
    await HiveDatabase().saveTransaction(newTransaction, false);
      _databaseBloc!.add(GetTransaction(widget.request));
      _selectedTransactions.remove(oldTransaction);
      _flipToViewBar();
  }

  Future<bool> _checkForSingleItem() async{
    if (_selectedTransactions.length != 1) {
      await showDialog(context: context, builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text("You can only edit one transaction at a time."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), 
            child: Text("Got it!")
          )
        ],
      ));
      return false;
    }
    return true;
  }

  String? validateAmount(String? amount) {
    if (amount == null) return "Empty amount not allowed";
    String currencyCode = HiveDatabase().selectedAccount!.currencyCode;
    Map<String, dynamic> currency = currencies[currencyCode]!;
    int decimal_digits = currency["decimal_digits"];
    int int_digits = 12-decimal_digits;
    String decimalSeparator = currency["decimal_separator"];
    RegExp regex = 
      RegExp("^[+,-] [0-9]{1,$int_digits}\\$decimalSeparator[0-9]{$decimal_digits}\$");
    if (!amount.contains(regex)) {
      String suffix = "0" + decimalSeparator + "0"*decimal_digits;
      return "Format has to be: + " + suffix + " or - " + suffix;
    } 
    return null;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _selectedTransactions.clear();
    super.dispose();
  }
}
