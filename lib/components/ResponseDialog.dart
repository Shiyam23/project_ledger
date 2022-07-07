import 'package:flutter/material.dart';

class ResponseDialog extends StatelessWidget {

  ResponseDialog({
    Key? key,
    required this.title,
    required this.response
  }) : super(key: key);

  final String title;
  final Response response;
  final Color red = Color.fromRGBO(223, 79, 95, 1);
  final Color green = Color.fromRGBO(52, 190, 166, 1);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Container(
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: (response == Response.Error) ? red : green,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))
        ),
        child: Text(
          response.name, 
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold
          )
        ),
      ),
      titlePadding: EdgeInsets.zero,
      titleTextStyle: TextStyle(
        inherit: true,
      ),
      contentPadding: EdgeInsets.only(top: 30, bottom: 30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          
          SizedBox(
            height: MediaQuery.of(context).size.height / 7,
            child: _getImage(response)
          ), 
          SizedBox(height: 40),
          SizedBox(
            width: 250,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor
                )
              ),
            ),
          ),
          SizedBox(height: 40), 
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: Text(
              "OK",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: response == Response.Error ? red : green,
              minimumSize: Size(170, 40),
              elevation: 15,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
              )
            )
          )
        ],
      ),
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