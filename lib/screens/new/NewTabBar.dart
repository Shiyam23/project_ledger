import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:dollavu/components/LayoutController.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewTabBar extends StatelessWidget implements PreferredSizeWidget {
  final void Function(int index) setPage;
  final LayoutController? layoutController;

  const NewTabBar({
    this.layoutController,
    required this.setPage,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: TabBar(
        dragStartBehavior: DragStartBehavior.down,
        onTap: (index) => setPage(index + 2),
        controller: layoutController!.newTabController,
        tabs: <Widget>[
          Text(
            AppLocalizations.of(context)!.income_expense,
          ),
          Text(
            AppLocalizations.of(context)!.templates,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
