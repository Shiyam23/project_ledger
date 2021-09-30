import 'package:flutter/material.dart';

class ViewBarIcon extends StatelessWidget {

  ViewBarIcon({
    Key? key,
    required this.width,
    required this.icon,
    this.onTap,
    this.tooltip
  }) : super(key: key);

  final double width;
  final IconData icon;
  final void Function()? onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: IconButton(
        tooltip: tooltip,
        icon: Icon(icon, size: width / 2),
        onPressed: () {
          onTap?.call();
        }),
    );
  }
}
