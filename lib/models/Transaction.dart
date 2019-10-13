import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/text.dart';
import 'package:intl/intl.dart';
import 'package:project_ez_finance/components/CategoryIcon.dart';
import 'package:project_ez_finance/models/SelectableTile.dart';

class Transaction with SelectableTile {
  String name;
  DateTime date;
  CategoryIcon icon;
  String amount;
  bool isExpense;

  Transaction(
      {@required this.name,
      @required this.date,
      @required this.icon,
      @required this.amount,
      @required this.isExpense});

  @override
  // TODO: implement rightText
  Text get rightText => Text(amount.toString());

  @override
  // TODO: implement secondaryTitle
  Text get secondaryTitle => Text(DateFormat("dd.MM.yyyy").format(date));

  @override
  // TODO: implement title
  Text get title => Text(name);
}
