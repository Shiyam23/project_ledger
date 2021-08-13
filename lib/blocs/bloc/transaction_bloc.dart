import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart' show DateTimeRange;
import 'package:hive/hive.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:project_ez_finance/blocs/bloc/transaction_event.dart';
import 'package:project_ez_finance/blocs/bloc/transaction_state.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIcon.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIconData.dart';
import 'package:project_ez_finance/models/Account.dart';
import 'package:project_ez_finance/models/Category.dart';
import 'package:project_ez_finance/models/Repetition.dart';
import 'package:project_ez_finance/models/Transaction.dart';
import 'package:project_ez_finance/models/filters/TransactionFilter.dart';
import './bloc.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  bool _added = true;
  TransactionRequest? _lastRequest;
  List<Transaction> _transactions = [];
  final Set<String> _boxes = {};
  final Set<Box?> _openBoxes = {};
  final TransactionFilter _filter = TransactionFilter();

  TransactionBloc(TransactionState initialState) : super(initialState) {
    setupDatabase();
  }

  @override
  Stream<TransactionState> mapEventToState(
    TransactionEvent event,
  ) async* {
    if (event is GetTransaction) {
      if (event.request != _lastRequest || _added) {
        yield TransactionLoading();
        if (await _refreshTransactions(event.request)) {
          yield TransactionLoaded(_transactions);
          _added = false;
        }
      }
    } else if (event is AddTransaction) {
      saveTransaction(event.transaction);
      yield TransactionLoaded(_transactions);
      _added = true;
    } else if (event is DeleteAll) {
      yield TransactionLoading();
      deleteAllTransactions();
      yield TransactionLoaded([]);
    } 
  }

  void saveTransaction(Transaction transaction) async {
    Box? currentBox = await _getBoxFromDate(transaction.date, createNew: true);
    if (currentBox != null) {
      currentBox.add(transaction);
      print("Saving into Box:" + currentBox.name);
      _transactions.add(transaction);
    }
  }

  void deleteAllTransactions() async {
    _transactions.clear();
    (await _getBoxFromDate(DateTime.now()))?.deleteFromDisk();
    (await Hive.openBox("boxes")).clear();
  }

  void setupDatabase() async {
    final appDocumentDir =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);

    // Registering all adapters
    Hive.registerAdapter(CategoryIconAdapter());
    Hive.registerAdapter(CategoryIconDataAdapter());
    Hive.registerAdapter(CategoryAdapter());
    Hive.registerAdapter(TransactionAdapter());
    Hive.registerAdapter(RepetitionAdapter());
    Hive.registerAdapter(CalenderUnitAdapter());
    Hive.registerAdapter(AccountAdapter());

    // Saving all box names
    _boxes.clear();
    (await Hive.openBox("boxes")).values.forEach((box) => _boxes.add(box));
    // Printing box names for debugging
    _boxes.forEach(print);
  }

  Future<Box?> _getBoxFromDate(DateTime date, {createNew = false}) async {
    String currentName =
        DateFormat.yMMM().format(date).replaceAll(" ", "").toLowerCase();
    if (createNew || await Hive.boxExists(currentName)) {
      print("Opening Box:" + currentName);
      Box nameBoxes = await Hive.openBox("boxes");
      if (!nameBoxes.values.contains(currentName)) nameBoxes.add(currentName);
      Box? currentBox = await Hive.openBox(currentName);
      _openBoxes.add(currentBox);
      return currentBox;
    }
    return null;
  }

  Future<bool> _refreshTransactions(TransactionRequest request) async {
    _transactions.clear();
    Set<DateTime> neededBoxesAsDateTime =
        _getIntermediateMonth(request.dateRange);
    Set<Box?> neededBoxes = (await Future.wait(
            neededBoxesAsDateTime.map((e) => _getBoxFromDate(e))))
        .toSet();
    neededBoxes.forEach((box) {
      box?.values.forEach((t) => _transactions.add(t));
      neededBoxes.add(box);
    });
    _filter.request = request;
    _transactions = _filter.filterList(_transactions);
    _lastRequest = TransactionRequest.clone(request: request);
    _openBoxes.difference(neededBoxes).forEach((box) {
      print("Closing " + (box?.name ?? "nothing"));
      box?.close();
      _openBoxes.remove(box);
    });
    return Future.value(true);
  }

  // Get all box names, which are needed (in DateTimeRange).
  Set<DateTime> _getIntermediateMonth(DateTimeRange dateRange) {
    Set<DateTime> neededBoxNames = {};
    DateTime dateTimei = DateTime(dateRange.start.year, dateRange.start.month);
    do {
      neededBoxNames.add(dateTimei);
      dateTimei = DateTime(dateTimei.year, dateTimei.month + 1);
    } while (dateTimei.isBefore(dateRange.end) ||
        dateTimei.isAtSameMomentAs(dateRange.end));
    return neededBoxNames;
  }

 
}
