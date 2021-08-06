import 'package:flutter/material.dart';

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
