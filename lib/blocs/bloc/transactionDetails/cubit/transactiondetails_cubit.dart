import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_ez_finance/models/Account.dart';
import 'package:project_ez_finance/models/Category.dart';
import 'package:project_ez_finance/models/Repetition.dart';

class TransactionDetailsCubit extends Cubit<TransactionDetails> {

  final TransactionDetails? transactionDetails = TransactionDetails();
  
  TransactionDetailsCubit() : super(
    TransactionDetails(
      repetition: Repetition.none,
      date: DateTime.now(),
      amount: 0
    )
  );

  static TransactionDetailsCubit of(BuildContext context) {
    return BlocProvider.of<TransactionDetailsCubit>(context);
  }

  void resetCategory() {
    emit(state.reset(category: true));
  }

}

class TransactionDetails extends Equatable {
  
  final String? name;
  final DateTime? date;
  final Category? category;
  final double? amount;
  final Repetition? repetition;
  final Account? account;
  final bool? isExpense;
  TransactionDetails({
    this.name,
    this.date,
    this.category,
    this.amount,
    this.repetition,
    this.account,
    this.isExpense
  });

  TransactionDetails copyWith({
    String? name,
    DateTime? date,
    Category? category,
    double? amount,
    Repetition? repetition,
    Account? account,
    bool? isExpense
  }) {
    return TransactionDetails(
      name: name ?? this.name,
      date: date ?? this.date,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      repetition: repetition ?? this.repetition,
      account: account ?? this.account,
      isExpense: isExpense ?? this.isExpense
    );
  }

  TransactionDetails reset({
    bool name = false,
    bool date = false,
    bool category = false,
    bool amount = false,
    bool repetition = false,
    bool account = false,
    bool isExpense = false
  }) {
    return TransactionDetails(
      name: name ? null : this.name,
      date: date ? DateTime.now() : this.date,
      category: category ? null : this.category,
      amount: amount ? null : this.amount,
      repetition: repetition ? Repetition.none : this.repetition,
      account: account ? null : this.account,
      isExpense: isExpense ? true : this.isExpense
    );
  }


  
  @override
  List<Object?> get props {
    return [
      name,
      date,
      category,
      amount,
      repetition,
      account,
      isExpense
    ];
  }
}
