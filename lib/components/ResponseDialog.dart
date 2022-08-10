import 'package:flutter/material.dart';

class ResponseDialog extends StatelessWidget {

  ResponseDialog({
    Key? key,
    required this.description,
    required this.response
  }) : super(key: key);

  final String description;
  final Response response;
  final Color red = Color.fromRGBO(223, 79, 95, 1);
  final Color green = Color.fromRGBO(52, 190, 166, 1);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        response.name, 
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      content: Text(description),
      actions: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Divider(
              height: 2,
              thickness: 2,
            ),
            TextButton(onPressed: Navigator.of(context).pop, child: Text("OK")),
          ],
        )
      ],
    );
  }

}

enum Response {
    Error,
    Success
}