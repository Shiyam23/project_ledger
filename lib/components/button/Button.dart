import 'package:flutter/material.dart';

class RoundGradientButton extends StatelessWidget {

  final String text;
  final void Function()? onPressed;
  final double widthRatio;

  const RoundGradientButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.widthRatio

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: width* widthRatio * 0.25,
      width: width * widthRatio,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
            Color.fromRGBO(56, 100, 132, 0.75),
            Color.fromRGBO(56, 100, 132, 1),
          ]
        ),
        borderRadius: BorderRadius.circular(50),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          //minimumSize: Size(150,40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        onPressed: onPressed, 
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Roboto",
            fontStyle: FontStyle.normal,
            fontSize: width * 0.035
          ),
          textAlign: TextAlign.center,
        )
      ),
    );
  }
}

class RoundButton extends StatelessWidget {

  final String text;
  final void Function()? onPressed;
  final double widthRatio;

  const RoundButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.widthRatio
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenWidth * widthRatio * 0.25,
      width: screenWidth * widthRatio,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: Theme.of(context).primaryColor
        )
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          //minimumSize: Size(150,40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        onPressed: onPressed, 
        child: Text(
          text,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontFamily: "Roboto",
            fontStyle: FontStyle.normal,
            fontSize: screenWidth * 0.035
          ),
          textAlign: TextAlign.center,
        )
      ),
    );
  }
}