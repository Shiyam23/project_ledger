import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math' as math;

class CategoryIcon extends StatefulWidget {
  final Color backgroundColor;
  final IconData icon;
  final Color iconColor;
  final bool selectable;
  final bool selected;
  final void Function() onTap;
  final AnimationController flipController;

  CategoryIcon({
    this.backgroundColor,
    this.icon,
    this.iconColor,
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
      widget.icon,
      color: widget.iconColor,
    );

    final Container frontSideContainer = Container(
      key: ValueKey(1),
      height: MediaQuery.of(context).size.width / 7,
      width: MediaQuery.of(context).size.width / 7,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.backgroundColor,
      ),
      child: frontSideIcon,
    );

    final Icon backSideIcon = Icon(
      FontAwesomeIcons.check,
      color: Colors.white,
    );

    final Container backSideContainer = Container(
      key: ValueKey(2),
      height: MediaQuery.of(context).size.width / 7,
      width: MediaQuery.of(context).size.width / 7,
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
    widget.onTap();
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }
}
