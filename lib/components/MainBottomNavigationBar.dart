import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_ez_finance/components/LayoutController.dart';
import 'package:project_ez_finance/themes/DTheme.dart';

class MainBottomNaviationBar extends StatefulWidget {
  //
  final LayoutController? layoutController;
  final void Function(int index) setPage;

  MainBottomNaviationBar(
      {required this.layoutController, required this.setPage, key})
      : super(key: key);

  _MainBottomNaviationBarState createState() =>
      _MainBottomNaviationBarState(this.layoutController, this.setPage);
}

class _MainBottomNaviationBarState extends State<MainBottomNaviationBar> {
  final LayoutController? lController;
  final void Function(int index) setPage;

  final List<BottomNavigationBarItem> bottomNavBarItems = [
    BottomNavigationBarItem(
        icon: new Icon(FontAwesomeIcons.book),
        title: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text('Overview'),
        )),
    BottomNavigationBarItem(
        icon: new Icon(FontAwesomeIcons.home),
        title: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text('Home'),
        )),
    BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.plusCircle),
        title: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text('New'),
        ))
  ];

  _MainBottomNaviationBarState(this.lController, this.setPage);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        backgroundColor: DTheme.of(context)!.themeData.bottomAppBarColor,
        currentIndex: lController!.bottomSelectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white38,
        items: bottomNavBarItems,
        onTap: (index) {
          lController!.bottomSelectedIndex = index;
          setPage(index);
          lController!.overViewTabController.index = 1;
          lController!.newTabController.index = 0;
        });
  }
}
