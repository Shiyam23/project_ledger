import 'package:equatable/equatable.dart';
import 'package:project_ez_finance/models/Transaction.dart';

abstract class DatabaseEvent extends Equatable {
  const DatabaseEvent();
}

class GetTransaction extends DatabaseEvent {
  @override
  List<Object> get props => [];
}

class DeleteAll extends DatabaseEvent {
  @override
  List<Object> get props => [];
}

class AddTransaction extends DatabaseEvent {
  final Transaction transaction;

  AddTransaction(this.transaction);

  @override
  List<Object> get props => [];
}
