import 'package:project_ez_finance/models/CategoryChartInfo.dart';
import 'package:project_ez_finance/models/Transaction.dart';

abstract class TransactionState {
  const TransactionState();
}

class TransactionInitial extends TransactionState {
  const TransactionInitial();
}

class TransactionLoading extends TransactionState {
  const TransactionLoading();
}

class TransactionLoaded extends TransactionState {
  final List<Transaction> transactionList;
  TransactionLoaded(this.transactionList);
}

class GraphLoaded extends TransactionState {
  final List<CategoryChartInfo> chartInfo;
  GraphLoaded(this.chartInfo);
}

