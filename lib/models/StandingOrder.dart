import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:dollavu/components/categoryIcon/CategoryIcon.dart';
import 'package:dollavu/models/SelectableTile.dart';
import 'package:dollavu/models/Transaction.dart';
import 'package:hive/hive.dart';
import 'package:dollavu/services/DateTimeFormatter.dart';
part 'StandingOrder.g.dart';

@HiveType(typeId: 7)
class StandingOrder extends SelectableTile with EquatableMixin {

  @HiveField(0)
  final Transaction initialTransaction;
  @HiveField(1)
  final double totalAmount;
  @HiveField(2)
  final DateTime nextDueDate;
  @HiveField(3)
  final int totalTransactions;

  StandingOrder({
    required this.initialTransaction, 
    required this.totalAmount, 
    required this.nextDueDate, 
    required this.totalTransactions
    });

  @override
  CategoryIcon? get icon => initialTransaction.icon;

  @override
  @override
  Text get rightText {
    return Text(
      (initialTransaction.isExpense ? "- " : "+ ") + initialTransaction.amountString,
      style: TextStyle(
        fontSize: 18,
        color: initialTransaction.isExpense ? Colors.red : Colors.green,
        fontWeight: FontWeight.w500
      )
    );
  }

  @override
  Text get secondaryTitle {
    return Text(
    "${initialTransaction.category.name}\n${nextDueDate.format()}"
    );
  }

  @override
  Text get title => Text(initialTransaction.name);

  @override
  List<Object?> get props => [this.initialTransaction]; 
}