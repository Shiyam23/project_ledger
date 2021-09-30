import 'dart:collection';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_ez_finance/blocs/bloc/transaction/transaction_bloc.dart';
import 'package:project_ez_finance/blocs/bloc/transaction/transaction_event.dart';
import 'package:project_ez_finance/blocs/bloc/transaction/transaction_state.dart';
import 'package:project_ez_finance/components/IconListTile.dart';
import 'package:project_ez_finance/models/Modes.dart';
import 'package:collection/collection.dart' show ListEquality;
import 'package:project_ez_finance/models/Transaction.dart';
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
    onEdit: onEdit
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
            if (state is TransactionLoaded) {
              return Flexible(
                child: Scrollbar(
                  child: ListView.builder(
                    key: ValueKey(state.transactionList.length),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: state.transactionList.length,
                    dragStartBehavior: DragStartBehavior.down,
                    itemBuilder: (BuildContext context, int index) {
                      Transaction transaction = state.transactionList[index];
                      return Card(
                        elevation: 3.0,
                        child: IconListTile(
                          onSelect: () => onTransactionSelect(transaction),
                          onTap: () => onTransactionSelect(transaction),
                          selectable: true,
                          selected: _selectedTransactions.contains(transaction),
                          key: ObjectKey(transaction),
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
  }

  void onDelete() async {
    _databaseBloc?.add(
      DeleteTransaction(
        _selectedTransactions.toList(), 
        HiveDatabase().selectedAccount!
      )
    );
    _selectedTransactions.clear();
    _flipToViewBar();
  }

  void onDeleteAll() {
    _databaseBloc?.add(const DeleteAllShownTransactions());
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
      return Wrap(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
            title: const Text("Edit name"),
            leading: const Icon(Icons.edit),
          ),
          const Divider(
            thickness: 1,
            height: 1,
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
            title: const Text("Change category"),
            leading: const Icon(Icons.circle),
          ),
          const Divider(
            thickness: 1,
            height: 1,
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
            title: const Text("Change date"),
            leading: const Icon(Icons.calendar_today),
          ),
          const Divider(
            thickness: 1,
            height: 1,
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
            title: const Text("Change amount"),
            leading: const Icon(Icons.money),
          ),
        ]
      );
    });    
  }

  @override
  void dispose() {
    _animationController.dispose();
    _selectedTransactions.clear();
    super.dispose();
  }
}
