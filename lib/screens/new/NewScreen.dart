import 'package:flutter/material.dart';

class NewScreen extends StatefulWidget {
  NewScreen({Key key}) : super(key: key);

  _NewScreenState createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("New Screen"),
      ),
    );
  }
}
