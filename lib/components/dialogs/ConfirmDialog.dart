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
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text("Cancel")
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text("Delete")
        ),
      ],
    );
  }
}