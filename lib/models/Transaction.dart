import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIcon.dart';
import 'package:project_ez_finance/models/Category.dart' as Dollavu;
import 'package:project_ez_finance/models/SelectableTile.dart';
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
  Dollavu.Category? category;
  @HiveField(3)
  String amount;
  @HiveField(4)
  bool isExpense;
  @HiveField(5)
  Repetition? repetition;
  @HiveField(6)
  Account account;
  @HiveField(7)
  DateTime addDateTime;

  Transaction(
      {required name,
      required category,
      required date,
      required amount,
      required isExpense,
      required repetition,
      required account,
      required addDateTime})
      : name = name,
        category = category,
        date = date,
        amount = amount,
        isExpense = isExpense,
        repetition = repetition,
        account = account,
        addDateTime = addDateTime;

  @override
  Text get rightText => Text(amount.toString(),
      style: TextStyle(
          fontSize: 18,
          color: isExpense ? Colors.red : Colors.green,
          fontWeight: FontWeight.w500));

  @override
  Text get secondaryTitle => Text(
        "${this.category!.name}\n" + DateFormat("dd.MM.yyyy").format(date),
        style: TextStyle(fontSize: 13),
      );

  @override
  Text get title => Text(name);

  @override
  List<Object?> get props => [
        name,
        date,
        icon,
        amount,
        isExpense,
        category,
        repetition,
        account,
        addDateTime
      ];

  @override
  // TODO: implement icon
  CategoryIcon? get icon => category!.icon;
}
