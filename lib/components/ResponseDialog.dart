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
        TextButton(onPressed: Navigator.of(context).pop, child: Text("OK"))
      ],
    );
  }

  Widget _getImage(Response response) {
    Image image;
    switch (response) {
      case Response.Error:
        image = Image.asset("assets/icons/close.png");
        break;
      case Response.Success:
        image = Image.asset("assets/icons/check.png");
        break;
    }
    return Material(
      elevation: 15,
      borderRadius: BorderRadius.circular(70),
      child: image
    );
      
  }  
}

enum Response {
    Error,
    Success
}