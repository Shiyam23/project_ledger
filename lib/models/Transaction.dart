import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:dollavu/components/categoryIcon/CategoryIcon.dart';
import 'package:dollavu/models/Category.dart' as Dollavu;
import 'package:dollavu/models/SelectableTile.dart';
import 'package:dollavu/services/DateTimeFormatter.dart';
import 'Account.dart';
import 'Repetition.dart';

part 'Transaction.g.dart';

@HiveType(typeId: 3)
// ignore: must_be_immutable
class Transaction extends Equatable implements SelectableTile {
  @HiveField(0)
  String name;
  @HiveField(1)
  DateTime date;
  @HiveField(2)
  Dollavu.Category category;
  @HiveField(3)
  double amount;
  @HiveField(4)
  bool isExpense;
  @HiveField(5)
  String amountString;
  @HiveField(6)
  Repetition repetition;
  @HiveField(9)
  Account account;
  @HiveField(10)
  DateTime addDateTime;

  Transaction({
    required this.name,
    required this.category,
    required this.date,
    required this.amount,
    required this.amountString,
    required this.isExpense,
    required this.repetition,
    required this.account,
    required this.addDateTime});
    

  @override
  Text get rightText {
    return Text(
      (isExpense ? "- " : "+ ") + amountString,
      style: TextStyle(
        fontSize: 18,
        color: isExpense ? Colors.red : Colors.green,
        fontWeight: FontWeight.w500
      )
    );
  }

  @override
  Text get secondaryTitle => Text(
        "${this.category.name}\n" + date.format(),
        style: TextStyle(fontSize: 13),
      );

  @override
  Text get title => Text(name);

  @override
  List<Object?> get props => [
        name,
        date,
        amount,
        isExpense,
        category,
        repetition,
        account,
        addDateTime
      ];

  @override
  CategoryIcon? get icon => category.icon;

  Transaction copyWith({
    name,
    category,
    date,
    amount,
    amountString,
    isExpense,
    repetition,
    account,
    addDateTime
  }) {
    return Transaction(
      name: name ?? this.name, 
      category: category ?? this.category, 
      date: date ?? this.date, 
      amount: amount ?? this.amount, 
      amountString: amountString ?? this.amountString, 
      isExpense: isExpense ?? this.isExpense, 
      repetition: repetition ?? this.repetition, 
      account: account ?? this.account, 
      addDateTime: addDateTime ?? this.addDateTime);
  }
}
