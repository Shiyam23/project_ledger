import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:project_ez_finance/models/Transaction.dart';
import 'package:project_ez_finance/models/filters/TransactionFilter.dart';
import './bloc.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  @override
  TransactionState get initialState => TransactionInitial();

  List<Transaction> transactions = List<Transaction>();
  var transactionBox = Hive.box("transaction");
  final TransactionFilter filter = TransactionFilter();
  bool initialRead = true;

  @override
  Stream<TransactionState> mapEventToState(
    TransactionEvent event,
  ) async* {
    if (event is GetTransaction) {
      yield TransactionLoading();
      readDatabase();
      yield TransactionLoaded(filter.filterList(transactions));
    } else if (event is AddTransaction) {
      saveToDatabase(event.transaction);
      yield TransactionLoaded(transactions);
    }
  }

  void saveToDatabase(Transaction transaction) async {
    await transactionBox.add(transaction);
    transactions.add(transaction);
  }

  void readDatabase() async {
    if (initialRead) {
      transactions.clear();
      transactionBox.values.forEach((item) => transactions.add(item));
    }
    ;
    initialRead = false;
  }
}
