import 'package:flutter/material.dart';
import 'package:project_ez_finance/blocs/bloc/bloc.dart';

import '../Transaction.dart';

class TransactionFilter {
  TransactionRequest? request;

  List<Transaction> filterList(List<Transaction> list) {
    List<Transaction> filteredlist = list;
    if (request == null) return filteredlist;
    filteredlist = _filterNames(filteredlist);
    filteredlist = _filterDateRange(filteredlist);
    return filteredlist;
  }

  List<Transaction> _filterNames(List<Transaction> list) {
    String? searchText = request!.searchText;
    if (searchText == null || searchText.isEmpty) return list;
    return list
        .where((t) => t.name.toLowerCase().contains(searchText.toLowerCase()))
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
}
