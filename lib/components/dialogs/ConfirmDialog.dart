import 'package:flutter/material.dart';

class ConfirmDeleteDialog extends StatelessWidget {

  final String title;
  final String content;

  const ConfirmDeleteDialog({
    Key? key,
    required this.title,
    required this.content
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      title: Text(title),
      content: Text(
        content, 
        textAlign: TextAlign.left,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel)
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(MaterialLocalizations.of(context).deleteButtonTooltip.toUpperCase())
        ),
      ],
    );
  }
}