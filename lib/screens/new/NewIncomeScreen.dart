import 'package:flutter/material.dart';

class NewIncomeScreen extends StatefulWidget {
  NewIncomeScreen({Key key}) : super(key: key);

  _NewIncomeScreenState createState() => _NewIncomeScreenState();
}

class _NewIncomeScreenState extends State<NewIncomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("New Income Screen"),
      ),
    );
  }
}
