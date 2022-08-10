import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextInputDialog extends StatelessWidget {
  TextInputDialog({
    Key? key,
    required this.controller,
    required this.prefixIcon,
    required this.title,
    this.validator,
    this.prefix,
    this.suffix,
    this.useNumberKeyboard = false
  }) : super(key: key);

  final TextEditingController controller;
  final Icon prefixIcon;
  final Text title;
  final String? Function(String?)? validator;
  final String? prefix;
  final String? suffix;
  final GlobalKey<FormFieldState> _formKey = GlobalKey();
  final bool useNumberKeyboard;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(20),
      title: title,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: TextFormField(
            key: _formKey,
            //keyboardType: useNumberKeyboard ? TextInputType.text : null,
            validator: validator,
            autovalidateMode: AutovalidateMode.always,   
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.of(context).pop(controller.text);
                      }
                    },
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