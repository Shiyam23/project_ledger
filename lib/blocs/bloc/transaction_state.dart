import 'package:flutter/material.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIcon.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIconData.dart';
import 'package:project_ez_finance/models/Account.dart';
import 'package:project_ez_finance/models/Transaction.dart';

abstract class TransactionState {
  const TransactionState();
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<Transaction> transactionList;
  TransactionLoaded(this.transactionList);
}


