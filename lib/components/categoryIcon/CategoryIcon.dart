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
  final void Function()? onTap;
  final ValueNotifier<bool>? selectedNotifier;
  final double? size;

  CategoryIcon({
    required this.iconData,
    this.onTap,
    this.selectedNotifier,
    this.size
  });

  @override
  _CategoryIconState createState() => _CategoryIconState();
}

class _CategoryIconState extends State<CategoryIcon>
    with SingleTickerProviderStateMixin {
  
  late bool isSelected = widget.selectedNotifier?.value ?? false;
  late AnimationController? _flipController =
        AnimationController(duration: Duration(milliseconds: 100), vsync: this);
  late Animation<double> _animation = 
    Tween<double>(begin: 0, end: (1 / 2) * math.pi).animate(_flipController!);

  @override
  Widget build(BuildContext context) {
    widget.selectedNotifier?.addListener(flip);
    final Icon frontSideIcon = Icon(
      widget.iconData.icon,
      size: widget.size,
      color: Color(
        widget.iconData.iconColorInt ?? Colors.white.value
        ),
    );

    final Container frontSideContainer = Container(
      key: ValueKey(1),
      height: MediaQuery.of(context).size.width / 7.5,
      width: MediaQuery.of(context).size.width / 7.5,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(widget.iconData.backgroundColorInt
        ?? Theme.of(context).primaryColor.value),
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
          shape: BoxShape.circle, color: Theme.of(context).colorScheme.secondary),
      child: backSideIcon,
    );

    return InkResponse(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: _flipController!,
        child: isSelected ? backSideContainer : frontSideContainer,
        builder: (context, child) =>  Transform(
          transform: Matrix4.rotationY(_animation.value),
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }

  void onTap() {
    if (widget.selectedNotifier != null) {
      widget.selectedNotifier!.value = !widget.selectedNotifier!.value;
    }
    widget.onTap?.call();
  }

  void flip() async {
    _flipController!.stop();
    if (widget.selectedNotifier != null) {
      await _flipController!.forward();
      setState(() => isSelected = widget.selectedNotifier!.value);
      await _flipController!.reverse();
    }
  }

  @override
  void dispose() {
    _flipController!.dispose();
    // widget.selectedNotifier?.removeListener(flip);
    super.dispose();
  }
}
