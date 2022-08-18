import 'package:flutter/material.dart';

class DollavuDialog extends StatelessWidget {
  const DollavuDialog({
    Key? key,
    this.child,
    this.title,
    this.padding = const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
    this.withButtons = true,
    this.onPressedSave,
    this.onPressedCancel,
  }) : super(key: key);

  final Widget? child;
  final Widget? title;
  final EdgeInsetsGeometry padding;
  final bool withButtons;
  final Function? onPressedSave;
  final Function? onPressedCancel;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: title,
      children: <Widget>[
        Divider(thickness: 2.0),
        Padding(
          padding: padding,
          child: child,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextButton(
              onPressed: onPressedCancel as void Function()? ?? () {},
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: onPressedSave as void Function()? ?? () {},
              child: Text("Save"),
            ),
          ],
        ),
      ],
    );
  }
}
