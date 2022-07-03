import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIcon.dart';
import 'package:project_ez_finance/models/SelectableTile.dart';
import 'package:project_ez_finance/models/Transaction.dart';
import 'package:hive/hive.dart';
import 'package:project_ez_finance/services/DateTimeFormatter.dart';
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
  Text get secondaryTitle => Text(
    "${initialTransaction.category.name}\nNext: ${nextDueDate.format()}"
  );

  @override
  Text get title => Text(initialTransaction.name);

  @override
  List<Object?> get props => []; 
}