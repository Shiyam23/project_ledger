import 'package:flutter/material.dart';


class DollavuDialog extends StatelessWidget {
  const DollavuDialog({
    Key? key,
    this.child,
    this.title,
    this.withButtons = true,
    this.onPressedSave,
    this.onPressedCancel,
  }) : super(key: key);

  final Widget? child;
  final Widget? title;
  final bool withButtons;
  final Function? onPressedSave;
  final Function? onPressedCancel;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: title,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      children: <Widget>[
        Divider(thickness: 2.0),
        child!,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TextButton(
              onPressed: onPressedCancel as void Function()? ?? () {},
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
            ),
            TextButton(
              onPressed: onPressedSave as void Function()? ?? () {},
              child:Text(MaterialLocalizations.of(context).okButtonLabel),
            ),
          ],
        ),
      ],
    );
  }
}
