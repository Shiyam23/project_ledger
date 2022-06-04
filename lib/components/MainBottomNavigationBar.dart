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
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: new Icon(FontAwesomeIcons.book),
      ),
      label: 'Overview'
    ),
    BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Icon(FontAwesomeIcons.house),
      ),
      label: 'Home'
    ),
    BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Icon(FontAwesomeIcons.circlePlus),
      ),
      label: 'New',
    )
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
