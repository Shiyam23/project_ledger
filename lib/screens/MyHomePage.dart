import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_ez_finance/screens/home/HomeScreen.dart';
import 'package:project_ez_finance/screens/new/NewScreen.dart';
import 'package:project_ez_finance/screens/view/ViewScreen.dart';
import 'package:project_ez_finance/screens/home/PopUpMenuButtonChoices.dart';

import 'package:project_ez_finance/themes/DTheme.dart';
import 'package:project_ez_finance/themes/DThemeDark.dart';
import 'package:project_ez_finance/themes/DThemeLight.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  TabController overViewTabController;
  TabController newTabController;
  int currentPage = 2;
  int bottomSelectedIndex = 1;

  final titleDollavuText = new Text(
    "Dollavu",
    style: new TextStyle(fontFamily: "Pacifico", fontSize: 28.0),
  );

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
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
  }

  @override
  void initState() {
    overViewTabController =
        TabController(length: 2, initialIndex: 1, vsync: this);
    newTabController = TabController(length: 3, initialIndex: 0, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getTopBar(currentPage),
      body: buildPageView(),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: DTheme.of(context).themeData.bottomAppBarColor,
          currentIndex: bottomSelectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white38,
          items: buildBottomNavBarItems(),
          onTap: (index) {
            bottomSelectedIndex = index;
            setPage(index);
            overViewTabController.index = 1;
            newTabController.index = 0;
          }),
    );
  }

  PageController pageController = PageController(
    initialPage: 2,
    keepPage: true,
  );

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) => pageChanged(index),
      children: <Widget>[
        Center(child: Text("Daueraufträge")),
        Center(child: Text("Transaktionen")),
        HomeScreen(),
        Center(child: Text("Expense")),
        Center(child: Text("Income")),
        Center(child: Text("Template")),
      ],
    );
  }

  void pageChanged(int index) {
    currentPage = index;
    if (pageController.page + index < 2) {
      overViewTabController.animateTo(index,
          duration: Duration(milliseconds: 500));
      return;
    }
    if (pageController.page + index > 6) {
      newTabController.animateTo(index - 3,
          duration: Duration(milliseconds: 500));
      return;
    }
    ;
    setState(() {
      bottomSelectedIndex = index - 1;
    });
  }

  void setPage(index) {
    setState(() {
      if ((currentPage - (index + 1)).abs() > 1)
        pageController.jumpToPage(index + 1);
      else
        pageController.animateToPage(index + 1,
            duration: Duration(milliseconds: 500), curve: Curves.ease);
      currentPage = index + 1;
    });
  }

  Widget getTopBar(index) {
    if (index < 2)
      return AppBar(
        title: TabBar(
          onTap: (index) => setPage(index - 1),
          indicatorColor: Colors.white,
          controller: overViewTabController,
          tabs: <Widget>[
            Text(
              "Daueraufträge",
              style: TextStyle(fontSize: 18.0),
            ),
            Text(
              "Transaktionen",
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      );
    if (index == 2)
      return AppBar(
        title: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: titleDollavuText,
            ),
          ],
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context) {
              return PopUpMenuButtonChoices.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      );
    if (index > 2)
      return AppBar(
        title: TabBar(
          onTap: (index) => setPage(index + 2),
          indicatorColor: Colors.white,
          controller: newTabController,
          tabs: <Widget>[
            Text(
              "Expense",
              style: TextStyle(fontSize: 18.0),
            ),
            Text(
              "Income",
              style: TextStyle(fontSize: 18.0),
            ),
            Text(
              "Template",
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      );
    return null;
  }

  choiceAction(String choice) {
    if (choice == PopUpMenuButtonChoices.Accounts) {
      print('This Konten Page is to do.');
    }
    if (choice == PopUpMenuButtonChoices.Categories) {
      print('This Kategorien Page is to do.');
    }
    if (choice == PopUpMenuButtonChoices.Backup) {
      print('This Backup Page is to do.');
    }
    if (choice == PopUpMenuButtonChoices.Setting) {
      print('This Einstellung Page is to do.');
    }
    if (choice == PopUpMenuButtonChoices.RateUs) {
      print('This BewerteUns? Page is to do.');
    }
    if (choice == PopUpMenuButtonChoices.AboutUs) {
      print('This Über Page is to do.');
    }
  }
}
