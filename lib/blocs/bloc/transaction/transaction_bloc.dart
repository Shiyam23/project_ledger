import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart' show DateTimeRange;
import 'package:dollavu/blocs/bloc/transaction/transaction_event.dart';
import 'package:dollavu/blocs/bloc/transaction/transaction_state.dart';
import 'package:dollavu/models/Repetition.dart';
import 'package:dollavu/models/Transaction.dart';
import 'package:dollavu/models/filters/TransactionFilter.dart';
import 'package:dollavu/services/Database.dart';
import 'package:dollavu/services/HiveDatabase.dart';

import '../../../models/StandingOrder.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  
  Database _database = HiveDatabase();
  TransactionRequest? _lastRequest;
  List<Transaction> _transactions = [];
  final TransactionFilter _filter = TransactionFilter();

  TransactionBloc(TransactionState initialState) : super(initialState) {
    on<GetTransaction>(_getTransaction);
    on<UpdateStandingOrderTransactions>(_updateAllStandingOrders);
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
        emit(TransactionLoaded(_transactions));
    }
  }
  
  void _updateAllStandingOrders(event, emit) async {
    List<StandingOrder> standingOrders = await _database.getStandingOrders();
    standingOrders.forEach(_updateStandingOrderTransactions);
  }

  void _addTransaction(AddTransaction event, emit) async {
    await _database.saveTransaction(event.transaction, event.templateChecked);
    if(event.transaction.repetition != Repetition.none) {
      _addStandingOrder(event.transaction);
    }
    emit(TransactionLoaded(_transactions));
  }

  void _addStandingOrder(Transaction transaction) async {
    DateTime? endDate = transaction.repetition.endDate;
    if (endDate != null && endDate.isBefore(transaction.date)) {
      throw ArgumentError("Repetition endDate must not be before transaction date");
    }
    StandingOrder standingOrder = StandingOrder(
      initialTransaction: transaction,
      nextDueDate: _addInterval(transaction.date, transaction.repetition),
      totalAmount: transaction.amount,
      totalTransactions: 1
    );
    await _database.saveStandingOrder(standingOrder);
    if (standingOrder.nextDueDate.isBefore(DateTime.now())) {
      _updateStandingOrderTransactions(standingOrder);
    }
  }

  void _updateStandingOrderTransactions(StandingOrder standingOrder) async {
    Repetition repetition = standingOrder.initialTransaction.repetition;
    DateTime? endDate = repetition.endDate;
    if (endDate != null && endDate.isBefore(DateTime.now())) {
      _database.deleteStandingOrder(standingOrder);
    } else {
      endDate = DateTime.now();
    }
    DateTime dueDate = standingOrder.nextDueDate;
    int numberTransactions = standingOrder.totalTransactions;
    while (dueDate.isBefore(endDate)) {
      _database.saveTransaction(
        standingOrder.initialTransaction.copyWith(
          date: dueDate,
          repetition: Repetition.none,
          addDateTime: DateTime.now()
        ), 
        false
      );
      dueDate = _addInterval(dueDate, repetition);
      numberTransactions++;
    }
    if (numberTransactions != standingOrder.totalTransactions) {
      StandingOrder newStandingOrder = StandingOrder(
        initialTransaction: standingOrder.initialTransaction,
        nextDueDate: dueDate,
        totalTransactions: numberTransactions,
        totalAmount: numberTransactions * standingOrder.initialTransaction.amount
      );
      await _database.updateStandingOrder(standingOrder, newStandingOrder);
    }
  }

  DateTime _addInterval(DateTime initialDate, Repetition repetition) {
    return DateTime(
      initialDate.year + (repetition.time == CalenderUnit.yearly ? repetition.amount! : 0), 
      initialDate.month + (repetition.time == CalenderUnit.monthly ? repetition.amount! : 0),
      initialDate.day + (repetition.time == CalenderUnit.daily ? repetition.amount! : 0),
    );
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
