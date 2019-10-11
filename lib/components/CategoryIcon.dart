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

  CategoryIcon({
    this.backgroundColor,
    this.icon,
    this.iconColor,
    this.selectable = true,
    this.selected = false,
    this.onTap,
  }) {
    assert(selectable == (selected != null));
  }

  @override
  _CategoryIconState createState() => _CategoryIconState();
}

class _CategoryIconState extends State<CategoryIcon>
    with SingleTickerProviderStateMixin {
  AnimationController _animController;
  Animation<double> _animation;
  bool isSelected;

  AnimationController get animation => _animController;
  @override
  void initState() {
    super.initState();
    isSelected = widget.selected;
    _animController =
        AnimationController(duration: Duration(milliseconds: 100), vsync: this);

    _animation =
        Tween<double>(begin: 0, end: (1 / 2) * math.pi).animate(_animController)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              isSelected = !isSelected;
              _animController.reverse();
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
    if (widget.selectable) _animController.forward();
    widget.onTap?.call();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }
}
