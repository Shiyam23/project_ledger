import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:project_ez_finance/components/LayoutController.dart';

class NewTabBar extends StatelessWidget implements PreferredSizeWidget {
  final void Function(int index)? setPage;
  final LayoutController? layoutController;

  const NewTabBar({this.layoutController, this.setPage, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: TabBar(
        dragStartBehavior: DragStartBehavior.down,
        onTap: (index) => setPage!(index + 2),
        indicatorColor: Colors.white,
        controller: layoutController!.newTabController,
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
            "Templates",
            style: TextStyle(fontSize: 18.0),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
