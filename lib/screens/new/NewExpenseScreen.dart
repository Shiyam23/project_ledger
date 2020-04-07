import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_ez_finance/blocs/bloc/bloc.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIcon.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIconData.dart';
import 'package:project_ez_finance/models/Category.dart';
import 'package:project_ez_finance/models/Transaction.dart';

class NewExpenseScreen extends StatefulWidget {
  NewExpenseScreen({Key key}) : super(key: key);

  _NewExpenseScreenState createState() => _NewExpenseScreenState();
}

class _NewExpenseScreenState extends State<NewExpenseScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: RaisedButton(
            onPressed: () => BlocProvider.of<TransactionBloc>(context)
                .dispatch(AddTransaction(Transaction(
                    amount: "2,00 €",
                    category: Category(name: "Test"),
                    date: DateTime.now(),
                    icon: CategoryIcon(
                      iconData: CategoryIconData(
                        backgroundColorName: "green",
                        iconName: "shopping",
                        iconColorName: "white",
                      ),
                    ),
                    isExpense: true,
                    name: Random().nextInt(10).toString()))),
            child: Text("New Expense Screen")),
      ),
    );
  }
}
