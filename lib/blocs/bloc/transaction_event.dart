import 'package:equatable/equatable.dart';
import 'package:project_ez_finance/models/Transaction.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();
}

class GetTransaction extends TransactionEvent {
  @override
  List<Object> get props => [];
}

class AddTransaction extends TransactionEvent {
  final Transaction transaction;

  AddTransaction(this.transaction);

  @override
  List<Object> get props => [];
}
