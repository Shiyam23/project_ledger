import 'package:flutter/material.dart';

class ViewBarIcon extends StatelessWidget {

  ViewBarIcon({
    Key? key,
    required this.width,
    required this.icon,
    this.onTap,
    this.tooltip,
    this.showIndicatorNotifier
  }) : super(key: key);

  final double width;
  final IconData icon;
  final void Function()? onTap;
  final String? tooltip;
  final ValueNotifier<bool>? showIndicatorNotifier;

  @override
  Widget build(BuildContext context) {
    if (showIndicatorNotifier != null) {
      return ValueListenableBuilder<bool>(
        valueListenable: showIndicatorNotifier!,
        child: IconButton(
          tooltip: tooltip,
          icon: Icon(icon, size: width / 2),
          onPressed: () {
            onTap?.call();
          }
        ),
        builder: (context, showIndicator, child) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: showIndicator ? Color(0xffba3636) : null,
            ),
            width: width,
            child: child
          );
        }
      );
    }
    return SizedBox(
      width: width,
      child: IconButton(
        tooltip: tooltip,
        icon: Icon(icon, size: width / 2),
        onPressed: () {
          onTap?.call();
        }
      ),
    );
  }

  List<Widget>  getIcon(bool showIndicator) {
    List<Widget> widgets = [
      IconButton(
        tooltip: tooltip,
        icon: Icon(icon, size: width / 2),
        onPressed: () {
          onTap?.call();
        }
      )
    ];
    if (showIndicator) {
      widgets.add(
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(8)
            ),
            width: 15,
            height: 15,
          ),
        )
      );
    }
    return widgets;
  }
}
