import 'package:flutter/material.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIcon.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIconData.dart';
import 'package:project_ez_finance/models/SelectableTile.dart';
import 'package:flutter/cupertino.dart';

class IconListTile extends StatefulWidget {
  final SelectableTile tile;
  final bool? selectable;
  final void Function()? onTap;
  final void Function()? onSelect;

  const IconListTile({
    required this.tile,
    required this.selectable,
    this.onTap, 
    this.onSelect, 
    Key? key
    }): super(key: key);

  @override
  _IconListTileState createState() => _IconListTileState();
}

class _IconListTileState extends State<IconListTile>
    with SingleTickerProviderStateMixin {
  AnimationController? flipController;
  CategoryIcon? icon;
  late SelectableTile tile;

  @override
  void initState() {
    super.initState();
    tile = widget.tile;
    CategoryIcon oldIcon = tile.icon!;

    flipController =
        AnimationController(duration: Duration(milliseconds: 100), vsync: this);

    icon = CategoryIcon(
      iconData: CategoryIconData(
        backgroundColorInt: oldIcon.iconData.backgroundColorInt,
        iconName: oldIcon.iconData.iconName,
        iconColorInt: oldIcon.iconData.iconColorInt,
      ),
      selectable: widget.selectable ?? false,
      selected: false,
      onTap: widget.onSelect,
      flipController: flipController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          onLongPress: () {
            if (widget.selectable ?? false) flipController!.forward();
            widget.onSelect?.call();
          },
          contentPadding: EdgeInsets.only(left: 20, right: 40),
          title: tile.title,
          subtitle: tile.secondaryTitle,
          isThreeLine: true,
          leading: icon,
          onTap: () {
            if (widget.selectable ?? false) flipController!.forward();
            widget.onTap?.call();
          },
          trailing: Center(widthFactor: 1, child: tile.rightText),
        ),
      ],
    );
  }
}
