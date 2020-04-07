import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'dart:math' as math;
import 'package:project_ez_finance/components/categoryIcon/CategoryIconData.dart';

part 'CategoryIcon.g.dart';

@HiveType(typeId: 0)
class CategoryIcon extends StatefulWidget {
  @HiveField(0)
  final CategoryIconData iconData;
  final bool selectable;
  final bool selected;
  final void Function() onTap;
  final AnimationController flipController;

  CategoryIcon({
    this.iconData,
    this.selectable = false,
    this.selected = false,
    this.onTap,
    this.flipController,
  });

  @override
  _CategoryIconState createState() => _CategoryIconState(flipController);
}

class _CategoryIconState extends State<CategoryIcon>
    with SingleTickerProviderStateMixin {
  //
  AnimationController _flipController;
  Animation<double> _animation;
  bool isSelected;

  _CategoryIconState(this._flipController);

  @override
  void initState() {
    super.initState();
    isSelected = widget.selected;
    _flipController ??=
        AnimationController(duration: Duration(milliseconds: 100), vsync: this);

    _animation =
        Tween<double>(begin: 0, end: (1 / 2) * math.pi).animate(_flipController)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              isSelected = !isSelected;
              _flipController.reverse();
            }
          });
  }

  @override
  Widget build(BuildContext context) {
    //

    final Icon frontSideIcon = Icon(
      widget.iconData.icon,
      color: widget.iconData.iconColor,
    );

    final Container frontSideContainer = Container(
      key: ValueKey(1),
      height: MediaQuery.of(context).size.width / 7.5,
      width: MediaQuery.of(context).size.width / 7.5,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.iconData.backgroundColor,
      ),
      child: frontSideIcon,
    );

    final Icon backSideIcon = Icon(
      FontAwesomeIcons.check,
      color: Colors.white,
    );

    final Container backSideContainer = Container(
      key: ValueKey(2),
      height: MediaQuery.of(context).size.width / 7.5,
      width: MediaQuery.of(context).size.width / 7.5,
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: Theme.of(context).colorScheme.primary),
      child: backSideIcon,
    );

    return InkResponse(
      onTap: () => flip(),
      child: Transform(
        transform: Matrix4.rotationY(_animation.value),
        alignment: Alignment.center,
        child: isSelected ? backSideContainer : frontSideContainer,
      ),
    );
  }

  void flip() {
    if (widget.selectable) _flipController.forward();
    widget.onTap?.call();
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }
}
