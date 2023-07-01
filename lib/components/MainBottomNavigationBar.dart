import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dollavu/components/LayoutController.dart';
import 'package:dollavu/themes/DTheme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  List<BottomNavigationBarItem> bottomNavBarItems(context) {
    return [
      BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: new Icon(FontAwesomeIcons.book),
        ),
        label: AppLocalizations.of(context)!.tab_overview
      ),
      BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Icon(FontAwesomeIcons.house),
        ),
        label: AppLocalizations.of(context)!.tab_home
      ),
      BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Icon(FontAwesomeIcons.circlePlus),
        ),
        label: AppLocalizations.of(context)!.tab_new,
      )
    ];
  }

  _MainBottomNaviationBarState(this.lController, this.setPage);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        backgroundColor: DTheme.of(context)!.themeData.bottomAppBarTheme.color,
        currentIndex: lController!.bottomSelectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white38,
        items: bottomNavBarItems(context),
        onTap: (index) {
          lController!.bottomSelectedIndex = index;
          setPage(index);
          lController!.overViewTabController.index = 1;
          lController!.newTabController.index = 0;
        });
  }
}
