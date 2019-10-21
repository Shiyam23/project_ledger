import 'package:equatable/equatable.dart';
import 'package:project_ez_finance/models/Transaction.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();
}

class TransactionInitial extends TransactionState {
  @override
  List<Object> get props => [];
}

class TransactionLoading extends TransactionState {
  @override
  List<Object> get props => [];
}

class TransactionLoaded extends TransactionState {
  final List<Transaction> transactionList;

  TransactionLoaded(this.transactionList);

  @override
  List<Object> get props => [transactionList];
}
