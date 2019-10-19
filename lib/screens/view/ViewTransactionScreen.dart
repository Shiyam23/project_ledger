import 'package:flutter/material.dart';
import 'package:project_ez_finance/screens/view/filterbar/ViewFilterBarSection.dart';

class ViewTransactionScreen extends StatefulWidget {
  ViewTransactionScreen({Key key}) : super(key: key);

  _ViewScreenState createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewTransactionScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[ViewFilterBarSection()],
    );
  }
}
