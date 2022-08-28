import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:project_ez_finance/components/LayoutController.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ViewTabBar extends StatelessWidget implements PreferredSizeWidget {
  final void Function(int index)? setPage;
  final LayoutController? layoutController;

  const ViewTabBar({this.layoutController, this.setPage, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: TabBar(
        dragStartBehavior: DragStartBehavior.down,
        onTap: (index) => setPage!(index - 1),
        indicatorColor: Colors.white,
        controller: layoutController!.overViewTabController,
        tabs: <Widget>[
          Text(
            AppLocalizations.of(context)!.repetition_tab,
            style: TextStyle(fontSize: 18.0),
          ),
          Text(
            AppLocalizations.of(context)!.transactions_tab,
            style: TextStyle(fontSize: 18.0),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
