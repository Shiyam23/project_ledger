import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:project_ez_finance/models/Account.dart';
import 'package:project_ez_finance/models/Modes.dart';
import 'package:project_ez_finance/models/Transaction.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();
}

class GetTransaction extends TransactionEvent {
  final TransactionRequest request;

  GetTransaction(this.request);

  @override
  List<Object?> get props => [request];
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
  final Account account;
  final bool templateChecked;

  AddTransaction(this.transaction, this.account, this.templateChecked);

  @override
  List<Object?> get props => [transaction, account, this.templateChecked];
}

class DeleteTransaction extends TransactionEvent {
  final List<Transaction> transactions;
  final Account account;

  DeleteTransaction(this.transactions, this.account);

  @override
  List<Object?> get props => [transactions, account];
}

class DeleteAllShownTransactions extends TransactionEvent {

  const DeleteAllShownTransactions();

  @override
  List<Object?> get props => [];
}


class TransactionRequest extends Equatable {
  final String? searchText;
  final ViewMode viewMode;
  final TimeMode timeMode;
  final SortMode sortMode;
  final DateTimeRange dateRange;

  TransactionRequest(
      {required String? searchText,
      required ViewMode viewMode,
      required TimeMode timeMode,
      required SortMode sortMode,
      required DateTimeRange dateRange})
      : searchText = searchText,
        viewMode = viewMode,
        timeMode = timeMode,
        sortMode = sortMode,
        dateRange = dateRange;

  TransactionRequest.clone({required TransactionRequest request})
      : searchText = request.searchText,
        timeMode = request.timeMode,
        viewMode = request.viewMode,
        sortMode = request.sortMode,
        dateRange = request.dateRange;

  TransactionRequest copyOf({
    String? searchText,
    ViewMode? viewMode,
    TimeMode? timeMode,
    SortMode? sortMode,
    DateTimeRange? dateRange
  }) {
    return TransactionRequest(
      searchText: searchText ?? this.searchText, 
      viewMode: viewMode ?? this.viewMode, 
      timeMode: timeMode ?? this.timeMode, 
      sortMode: sortMode ?? this.sortMode, 
      dateRange: dateRange ?? this.dateRange);
  }

  @override
  List<Object?> get props =>
      [searchText, viewMode, timeMode, sortMode, dateRange];
}


