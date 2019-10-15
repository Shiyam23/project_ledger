import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/text.dart';
import 'package:intl/intl.dart';
import 'package:project_ez_finance/components/CategoryIcon.dart';
import 'package:project_ez_finance/models/Category.dart' as Dollavu;
import 'package:project_ez_finance/models/SelectableTile.dart';

class Transaction implements SelectableTile {
  String name;
  DateTime date;
  CategoryIcon icon;
  String amount;
  bool isExpense;
  Dollavu.Category category;

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
}
