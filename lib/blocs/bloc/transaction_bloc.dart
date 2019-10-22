import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_ez_finance/components/CategoryIcon.dart';
import 'package:project_ez_finance/models/Category.dart';
import 'package:project_ez_finance/models/Transaction.dart';
import 'package:project_ez_finance/models/filters/TransactionFilter.dart';
import './bloc.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  @override
  TransactionState get initialState => TransactionInitial();

  List<Transaction> transactions = [
    Transaction(
        amount: "243,23 €",
        category: Category(name: "Kleidung"),
        date: DateTime.now(),
        icon: CategoryIcon(
          backgroundColor: Colors.green,
          icon: FontAwesomeIcons.tshirt,
          iconColor: Colors.white,
        ),
        isExpense: true,
        name: "Schuhe")
  ];

  final TransactionFilter filter = TransactionFilter();

  @override
  Stream<TransactionState> mapEventToState(
    TransactionEvent event,
  ) async* {
    if (event is GetTransaction) {
      yield TransactionLoading();
      //await _fetchTransaction();
      yield TransactionLoaded(filter.filterList(transactions));
    } else if (event is AddTransaction) {
      transactions.add(event.transaction);
      yield TransactionLoaded(transactions);
    }
  }

  Future<void> _fetchTransaction() {
    return Future.delayed(Duration(milliseconds: 500));
  }
}
