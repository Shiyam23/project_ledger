import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIcon.dart';
import 'package:project_ez_finance/models/Category.dart' as Dollavu;
import 'package:project_ez_finance/models/SelectableTile.dart';
import 'Repetition.dart';

part 'Transaction.g.dart';

@HiveType(typeId: 3)
class Transaction extends Equatable implements SelectableTile {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final DateTime date;
  @HiveField(2)
  final CategoryIcon icon;
  @HiveField(3)
  final String amount;
  @HiveField(4)
  final bool isExpense;
  @HiveField(5)
  final Dollavu.Category category;
  @HiveField(6)
  final Repetition repetition;

  Transaction(
      {@required this.name,
      @required this.category,
      @required this.date,
      @required this.icon,
      @required this.amount,
      @required this.isExpense,
      this.repetition = Repetition.none});

  @override
  Text get rightText => Text(amount.toString(),
      style: TextStyle(
          fontSize: 18,
          color: isExpense ? Colors.red : Colors.green,
          fontWeight: FontWeight.w500));

  @override
  Text get secondaryTitle => Text(
        "${this.category.name}\n" + DateFormat("dd.MM.yyyy").format(date),
        style: TextStyle(fontSize: 13),
      );

  @override
  Text get title => Text(name);

  @override
  List<Object> get props => [name, date, icon, amount, isExpense, category];
}
