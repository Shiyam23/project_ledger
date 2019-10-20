import 'package:flutter/material.dart';
import 'package:project_ez_finance/components/LayoutController.dart';

class ViewTabBar extends StatelessWidget implements PreferredSizeWidget {
  final void Function(int index) setPage;
  final LayoutController layoutController;

  const ViewTabBar({this.layoutController, this.setPage, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: TabBar(
        onTap: (index) => setPage(index - 1),
        indicatorColor: Colors.white,
        controller: layoutController.overViewTabController,
        tabs: <Widget>[
          Text(
            "Standing orders",
            style: TextStyle(fontSize: 18.0),
          ),
          Text(
            "Transactions",
            style: TextStyle(fontSize: 18.0),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
