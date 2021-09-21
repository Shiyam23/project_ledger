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

class TemplateLoaded extends TransactionState {
  final Transaction template;
  TemplateLoaded(this.template);
}

