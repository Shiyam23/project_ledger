import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart' show DateTimeRange;
import 'package:project_ez_finance/blocs/bloc/transaction/transaction_event.dart';
import 'package:project_ez_finance/blocs/bloc/transaction/transaction_state.dart';
import 'package:project_ez_finance/models/Transaction.dart';
import 'package:project_ez_finance/models/filters/TransactionFilter.dart';
import 'package:project_ez_finance/services/Database.dart';
import 'package:project_ez_finance/services/HiveDatabase.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  
  Database _database = HiveDatabase();
  TransactionRequest? _lastRequest;
  List<Transaction> _transactions = [];
  final TransactionFilter _filter = TransactionFilter();

  TransactionBloc(TransactionState initialState) : super(initialState) {
    on<GetTransaction>(_getTransaction);
    on<AddTransaction>(_addTransaction);
    on<DeleteTransaction>(_deleteTransaction);
    on<DeleteAllShownTransactions>((event, emit) async {
      emit(const TransactionLoading());
      await _database.deleteTransactions(_transactions);
      _refreshTransactions(_lastRequest!);
      emit(TransactionLoaded(_transactions));
    });
  }

  void _getTransaction(event, emit) async {
    if (event.request != _lastRequest || _database.changed) {
        emit(const TransactionLoading());
        await _refreshTransactions(event.request);
        emit(TransactionLoaded(_transactions));
    }
  }

  void _addTransaction(event, emit) async {
    await _database.saveTransaction(event.transaction, event.templateChecked);
    emit(TransactionLoaded(_transactions));
  }

  void _deleteTransaction(event, emit) async {
    emit(const TransactionLoading());
    await _database.deleteTransactions(event.transactions);
    await _refreshTransactions(_lastRequest!);
    emit (TransactionLoaded(_transactions));
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
