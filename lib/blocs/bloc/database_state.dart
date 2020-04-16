import 'package:equatable/equatable.dart';
import 'package:project_ez_finance/models/Transaction.dart';

abstract class DatabaseState extends Equatable {
  const DatabaseState();
}

class TransactionInitial extends DatabaseState {
  @override
  List<Object> get props => [];
}

class TransactionLoading extends DatabaseState {
  @override
  List<Object> get props => [];
}

class TransactionLoaded extends DatabaseState {
  final List<Transaction> transactionList;

  TransactionLoaded(this.transactionList);

  @override
  List<Object> get props => [transactionList];
}
