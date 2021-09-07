import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextInputDialog extends StatelessWidget {
  const TextInputDialog({
    Key? key,
    required this.controller,
    required this.prefixIcon,
    required this.title,
  }) : super(key: key);

  final TextEditingController controller;
  final Icon prefixIcon;
  final Text title;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(20),
      title: title,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: TextField(
            onSubmitted: (text) => Navigator.of(context).pop(text),
            autofocus: true,
            controller: controller,
            maxLength: 30,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            style: const TextStyle(
              fontSize: 20 
            ),
            decoration: InputDecoration(
              prefixIcon: prefixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20)
              )
            )
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Column(
            children: [
              const Divider(
                thickness: 2,
                height: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: Navigator.of(context).pop,
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(controller.text),
                    child: const Text("Save"),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}