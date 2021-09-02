import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart' show DateTimeRange;
import 'package:project_ez_finance/blocs/bloc/transaction_event.dart';
import 'package:project_ez_finance/blocs/bloc/transaction_state.dart';
import 'package:project_ez_finance/models/Account.dart';
import 'package:project_ez_finance/models/Transaction.dart';
import 'package:project_ez_finance/models/filters/TransactionFilter.dart';
import 'package:project_ez_finance/services/Database.dart';
import 'package:project_ez_finance/services/HiveDatabase.dart';
import './bloc.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  
  Database _database = HiveDatabase();
  bool _added = true;
  Account? _selectedAccount;
  TransactionRequest? _lastRequest;
  List<Transaction> _transactions = [];
  final TransactionFilter _filter = TransactionFilter();

  TransactionBloc(TransactionState initialState) : super(initialState) {
    _database.setupDatabase();
    _selectedAccount = _database.selectedAccount;
  }

  @override
  Stream<TransactionState> mapEventToState(
    TransactionEvent event,
  ) async* {
    if (event is GetTransaction) {
      bool accountChanged = _selectedAccount != _database.selectedAccount;
      if (event.request != _lastRequest || _added || accountChanged) {
        yield TransactionLoading();
        await _refreshTransactions(event.request);
        yield TransactionLoaded(_transactions);
        _added = false;
        _selectedAccount = _database.selectedAccount;
      }
    } else if (event is AddTransaction) {
      _database.saveTransaction(event.transaction);
      yield TransactionLoaded(_transactions);
      _added = true;
    } else if (event is DeleteAll) {
      yield TransactionLoading();
      _database.deleteAllTransactions();
      yield TransactionLoaded([]);
    } 
  }

  Future<void> _refreshTransactions(TransactionRequest request) async {
    _transactions.clear();
    Set<DateTime> months = _getIntermediateMonth(request.dateRange);
    List<Transaction> listOfTransaction = await _database.getTransactions(months);
    _filter.request = request;
    _transactions = _filter.filterList(listOfTransaction);
    _lastRequest = TransactionRequest.clone(request: request);
  }

  // Get all months, which are needed (in DateTimeRange).
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
