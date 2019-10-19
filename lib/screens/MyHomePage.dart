import 'package:flutter/material.dart';
import 'package:project_ez_finance/components/LayoutController.dart';
import 'package:project_ez_finance/components/MainBottomNavigationBar.dart';
import 'package:project_ez_finance/screens/home/HomeAppBar.dart';
import 'package:project_ez_finance/screens/home/HomeScreen.dart';
import 'package:project_ez_finance/screens/new/NewTabBar.dart';
import 'package:project_ez_finance/screens/view/ViewTabBar.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  //
  LayoutController lController;

  @override
  void initState() {
    lController = LayoutController(
        bottomSelectedIndex: 1,
        currentPage: 2,
        newTabController:
            TabController(length: 3, initialIndex: 0, vsync: this),
        overViewTabController:
            TabController(length: 2, initialIndex: 1, vsync: this),
        pageController: PageController(initialPage: 2, keepPage: true));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getTopBar(lController.currentPage),
        body: buildPageView(),
        bottomNavigationBar: MainBottomNaviationBar(
          layoutController: lController,
          setPage: setPage,
        ));
  }

  Widget buildPageView() {
    return PageView(
      controller: lController.pageController,
      onPageChanged: (index) => pageChanged(index),
      children: <Widget>[
            Center(child: Text("Daueraufträge")),
            Center(child: Text("Transaktionen")),
          ] +
          <Widget>[
            HomeScreen(),
            Center(child: Text("Expense")),
            Center(child: Text("Income")),
            Center(child: Text("Template")),
          ],
    );
  }

  void pageChanged(int index) {
    lController.currentPage = index;
    if (lController.pageController.page + index < 2) {
      lController.overViewTabController
          .animateTo(index, duration: Duration(milliseconds: 500));
      return;
    }
    if (lController.pageController.page + index > 6) {
      lController.newTabController
          .animateTo(index - 3, duration: Duration(milliseconds: 500));
      return;
    }
    setState(() {
      lController.bottomSelectedIndex = index - 1;
    });
  }

  void setPage(index) {
    if ((lController.currentPage - (index + 1)).abs() > 1)
      lController.pageController.jumpToPage(index + 1);
    else
      lController.pageController.animateToPage(index + 1,
          duration: Duration(milliseconds: 300), curve: Curves.ease);
    lController.currentPage = index + 1;
  }

  Widget getTopBar(int index) {
    if (index < 2)
      return ViewTabBar(
        layoutController: lController,
        setPage: setPage,
      );
    if (index == 2) return HomeAppBar();
    if (index > 2)
      return NewTabBar(
        layoutController: lController,
        setPage: setPage,
      );
    return null;
  }
}
