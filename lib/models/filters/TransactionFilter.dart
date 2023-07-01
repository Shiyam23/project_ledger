import 'package:flutter/material.dart';
import 'package:dollavu/blocs/bloc/bloc.dart';
import 'package:dollavu/models/Category.dart';
import 'package:dollavu/models/Modes.dart';

import '../Transaction.dart';

class TransactionFilter {
  TransactionRequest? request;

  List<Transaction> filterList(List<Transaction> list) {
    List<Transaction> filteredlist = list;
    if (request == null) return filteredlist;
    filteredlist = _filterNames(filteredlist);
    filteredlist = _filterCategory(filteredlist);
    filteredlist = _filterDateRange(filteredlist);
    filteredlist = _sortTransactions(filteredlist);
    return filteredlist;
  }

  List<Transaction> _filterNames(List<Transaction> list) {
    String? searchText = request!.searchText;
    if (searchText == null || searchText.isEmpty) return list;
    return list
        .where((t) => t.name.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
  }

  List<Transaction> _filterCategory(List<Transaction> list) {
    Category? category = request!.categoryFilter;
    if (category == null) return list;
    return list
        .where((t) => t.category == category)
        .toList();
  }

  List<Transaction> _filterDateRange(List<Transaction> list) {
    DateTimeRange dateRange = request!.dateRange;
    return list
        .where((t) =>
            t.date.isAtSameMomentAs(dateRange.start) ||
            (t.date.isBefore(dateRange.end) && t.date.isAfter(dateRange.start)))
        .toList();
  }

  List<Transaction> _sortTransactions(List<Transaction> list) {
    if (request!.sortMode == SortMode.DateAsc) {
      list.sort((t1, t2) => t1.date.compareTo(t2.date));
    }
    if (request!.sortMode == SortMode.DateDesc) {
      list.sort((t1, t2) => t2.date.compareTo(t1.date));
    }
    if (request!.sortMode == SortMode.AmountAsc) {
      list.sort((t1, t2) => t1.amount.compareTo(t2.amount));
    }
    if (request!.sortMode == SortMode.AmountDesc) {
      list.sort((t1, t2) => t2.amount.compareTo(t1.amount));
    }
    if (request!.sortMode == SortMode.NameAsc) {
      list.sort((t1, t2) => t1.name.compareTo(t2.name));
    }
    if (request!.sortMode == SortMode.NameDesc) {
      list.sort((t1, t2) => t2.name.compareTo(t1.name));
    }
    if (request!.sortMode == SortMode.CategoryAsc) {
      list.sort((t1, t2) => t1.category.name!.compareTo(t2.category.name!));
    }
    if (request!.sortMode == SortMode.CategoryDesc) {
      list.sort((t1, t2) => t2.category.name!.compareTo(t1.category.name!));
    }
    return list;
  }
}
