import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:project_ez_finance/models/Modes.dart';
import 'package:project_ez_finance/models/Transaction.dart';
import '../../../models/Category.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();
}

class GetTransaction extends TransactionEvent {
  final TransactionRequest request;

  GetTransaction(this.request);

  @override
  List<Object?> get props => [request];
}

class UpdateStandingOrderTransactions extends TransactionEvent {

  UpdateStandingOrderTransactions();

  @override
  List<Object?> get props => [];
}

class GetGraph extends TransactionEvent {
  
  const GetGraph();

  @override
  List<Object?> get props => [];
}

class LoadTemplate extends TransactionEvent {
  final Transaction template;
  LoadTemplate(this.template);
  @override
  List<Object?> get props => [template];
}

class AddTransaction extends TransactionEvent {
  final Transaction transaction;
  final bool templateChecked;

  AddTransaction(this.transaction, this.templateChecked);

  @override
  List<Object?> get props => [transaction, this.templateChecked];
}

class DeleteTransaction extends TransactionEvent {
  final List<Transaction> transactions;

  DeleteTransaction(this.transactions);

  @override
  List<Object?> get props => [transactions];
}

class DeleteAllShownTransactions extends TransactionEvent {

  const DeleteAllShownTransactions();

  @override
  List<Object?> get props => [];
}


class TransactionRequest extends Equatable {
  final String? searchText;
  final Category? categoryFilter;
  final TimeMode timeMode;
  final SortMode sortMode;
  final DateTimeRange dateRange;

  TransactionRequest(
      {required String? searchText,
      required Category? categoryFilter,
      required TimeMode timeMode,
      required SortMode sortMode,
      required DateTimeRange dateRange})
      : searchText = searchText,
        categoryFilter = categoryFilter,
        timeMode = timeMode,
        sortMode = sortMode,
        dateRange = dateRange;

  TransactionRequest.clone({required TransactionRequest request})
      : searchText = request.searchText,
        timeMode = request.timeMode,
        categoryFilter = request.categoryFilter,
        sortMode = request.sortMode,
        dateRange = request.dateRange;

  TransactionRequest copyOf({
    String? searchText,
    Category? categoryFilter,
    TimeMode? timeMode,
    SortMode? sortMode,
    DateTimeRange? dateRange
  }) {
    return TransactionRequest(
      searchText: searchText ?? this.searchText, 
      categoryFilter: categoryFilter, 
      timeMode: timeMode ?? this.timeMode, 
      sortMode: sortMode ?? this.sortMode, 
      dateRange: dateRange ?? this.dateRange);
  }

  @override
  List<Object?> get props =>
      [searchText, categoryFilter, timeMode, sortMode, dateRange];
}


