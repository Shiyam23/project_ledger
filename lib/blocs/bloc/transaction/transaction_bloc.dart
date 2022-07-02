import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart' show DateTimeRange;
import 'package:project_ez_finance/blocs/bloc/transaction/transaction_event.dart';
import 'package:project_ez_finance/blocs/bloc/transaction/transaction_state.dart';
import 'package:project_ez_finance/models/CategoryChartInfo.dart';
import 'package:project_ez_finance/models/Modes.dart';
import 'package:project_ez_finance/models/Repetition.dart';
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
    on<UpdateRepetitionTransactions>(_updateRepetitonTransactions);
    on<GetGraph>(_getGraph);
    on<AddTransaction>(_addTransaction);
    on<DeleteTransaction>(_deleteTransaction);
    on<DeleteAllShownTransactions>((event, emit) async {
      emit(const TransactionLoading());
      await _database.deleteTransactions(_transactions);
      _refreshTransactions(_lastRequest!);
      emit(TransactionLoaded(_transactions));
    });
  }

  void _getTransaction(GetTransaction event, emit) async {
    if (event.request != _lastRequest || _database.changed) {
        emit(const TransactionLoading());
        await _refreshTransactions(event.request);
        if (event.request.viewMode == ViewMode.List) {
          emit(TransactionLoaded(_transactions));
        } else {
          List<CategoryChartInfo> categoryList 
            = await CategoryChartInfo.getCategories(transactions: _transactions);
          emit(GraphLoaded(categoryList));
        }
    }
  }

  void _getGraph(event, emit) async {
    emit(const TransactionLoading());
  }
  
  void _updateRepetitonTransactions(event, emit) async {
    List<Transaction> repetitions = await _database.getRepetitions();
    repetitions.forEach(_addRepetitionTransactions);
  }

  void _addTransaction(AddTransaction event, emit) async {
    await _database.saveTransaction(event.transaction, event.templateChecked);
    if(event.transaction.repetition != Repetition.none) {
      _addRepetitionTransactions(event.transaction);
    }
    emit(TransactionLoaded(_transactions));
  }

  void _addRepetitionTransactions(Transaction standingOrder) {
    Repetition repetition = standingOrder.repetition;
    DateTime endDate = DateTime.now();
    if (repetition.endDate != null && repetition.endDate!.isBefore(endDate)) {
      endDate = repetition.endDate!;
      HiveDatabase().deleteRepetition(standingOrder);
    }
    DateTime initialDate = standingOrder.date;
    DateTime addInterval(DateTime initialDate, Repetition repetition) {
      return DateTime(
      initialDate.year + (repetition.time == CalenderUnit.yearly ? repetition.amount! : 0), 
      initialDate.month + (repetition.time == CalenderUnit.monthly ? repetition.amount! : 0),
      initialDate.day + (repetition.time == CalenderUnit.daily ? repetition.amount! : 0),
      );
    }
    while ((initialDate = addInterval(initialDate, repetition)).isBefore(endDate)) {
      _database.saveTransaction(
        standingOrder.copyWith(
          date: initialDate,
          repetition: Repetition.none,
        ), 
        false
      );
    }
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
