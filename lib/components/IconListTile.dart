import 'package:flutter/material.dart';
import 'package:dollavu/components/categoryIcon/CategoryIcon.dart';
import 'package:dollavu/components/categoryIcon/CategoryIconData.dart';
import 'package:dollavu/models/SelectableTile.dart';

class IconListTile extends StatelessWidget {
  
  final SelectableTile tile;
  final void Function()? onTap;
  final void Function()? onSelect;
  late final void Function() flip;
  final ValueNotifier<bool>? selectedNotifier;
  late final CategoryIcon? icon = CategoryIcon(
    selectedNotifier: selectedNotifier,
    iconData: CategoryIconData(
      backgroundColorInt: tile.icon!.iconData.backgroundColorInt,
      iconName: tile.icon!.iconData.iconName,
      iconColorInt: tile.icon!.iconData.iconColorInt,
    ),
    onTap: onSelect,
  );


  IconListTile({
    required this.tile,
    bool selectable = false,
    this.onTap,
    this.onSelect,
    bool selected = false,
    Key? key
  }): 
  selectedNotifier = selectable ? ValueNotifier<bool>(selected) : null,
  super(key: key);


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          onLongPress: () {
            if (selectedNotifier != null) selectedNotifier!.value = !selectedNotifier!.value;
            onSelect?.call();
          },
          contentPadding: EdgeInsets.only(left: 20, right: 40),
          title: tile.title,
          subtitle: tile.secondaryTitle,
          isThreeLine: true,
          leading: icon,
          onTap: () {
            if (selectedNotifier != null) selectedNotifier!.value = !selectedNotifier!.value;
            onTap?.call();
          },
          trailing: Center(widthFactor: 1, child: tile.rightText),
        ),
      ],
    );
  }
}
