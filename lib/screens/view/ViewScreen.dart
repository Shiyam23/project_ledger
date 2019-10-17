import 'package:flutter/material.dart';

class ViewScreen extends StatefulWidget {
  ViewScreen({Key key}) : super(key: key);

  _ViewScreenState createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  @override
  Widget build(BuildContext context) {
    return buildPageView();
  }

  PageController pageController = PageController(
    initialPage: 1,
    keepPage: true,
  );

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      children: <Widget>[
        Center(child: Text("Daueraufträge")),
        Center(child: Text("Transaktionen"))
      ],
    );
  }
}
