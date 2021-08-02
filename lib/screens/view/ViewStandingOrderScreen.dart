import 'package:flutter/material.dart';
import 'package:project_ez_finance/screens/view/filterbar/ViewFilterBarSection.dart';

class ViewStandingOrderScreen extends StatefulWidget {
  ViewStandingOrderScreen({Key? key}) : super(key: key);

  _ViewScreenState createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewStandingOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Daueraufträge"));
  }
}
