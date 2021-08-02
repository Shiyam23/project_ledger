import 'package:flutter/material.dart';

class NewTemplateScreen extends StatefulWidget {
  NewTemplateScreen({Key? key}) : super(key: key);

  _NewTemplateScreenState createState() => _NewTemplateScreenState();
}

class _NewTemplateScreenState extends State<NewTemplateScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("New Template Screen"),
      ),
    );
  }
}
