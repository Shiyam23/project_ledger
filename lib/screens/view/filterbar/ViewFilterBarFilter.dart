import 'package:flutter/material.dart';

class ViewFilterBarFilter extends StatelessWidget {
  const ViewFilterBarFilter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Center(child: Text("filter")),
          ),
        ),
      ],
    );
  }
}
