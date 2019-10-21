import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/text.dart';
import 'package:intl/intl.dart';
import 'package:project_ez_finance/components/CategoryIcon.dart';
import 'package:project_ez_finance/models/Category.dart' as Dollavu;
import 'package:project_ez_finance/models/SelectableTile.dart';

class Transaction extends Equatable implements SelectableTile {
  final String name;
  final DateTime date;
  final CategoryIcon icon;
  final String amount;
  final bool isExpense;
  final Dollavu.Category category;

  Transaction(
      {@required this.name,
      @required this.category,
      @required this.date,
      @required this.icon,
      @required this.amount,
      @required this.isExpense});

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
