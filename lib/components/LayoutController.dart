import 'package:flutter/material.dart';

class LayoutController {
  int bottomSelectedIndex;
  final TabController overViewTabController;
  final TabController newTabController;
  final PageController pageController;
  int? currentPage;

  LayoutController(
      {required this.bottomSelectedIndex,
      required this.newTabController,
      required this.overViewTabController,
      required this.pageController,
      required this.currentPage});
}
