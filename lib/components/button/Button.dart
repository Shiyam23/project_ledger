import 'package:flutter/material.dart';

class RoundGradientButton extends StatelessWidget {

  final String text;
  final void Function()? onPressed;
  final double widthRatio;
  final double fontSizeFactor;

  const RoundGradientButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.widthRatio,
    this.fontSizeFactor = 1
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return RoundButton(
      onPressed: onPressed, 
      text: text, 
      widthRatio: widthRatio,
      fontSizeFactor: fontSizeFactor,
      gradient: LinearGradient(
        colors: [
          Theme.of(context).colorScheme.tertiary,
          Theme.of(context).colorScheme.secondary,
        ]
      ),
      textColor: Colors.white,
    );
  }
}

class WhiteRoundButton extends StatelessWidget {
  
  final void Function()? onPressed;
  final String text;
  final double widthRatio;
  final double fontSizeFactor;
  
  WhiteRoundButton({
    required this.onPressed,
    required this.text, 
    required this.widthRatio,
    this.fontSizeFactor = 1
  });

  @override
  Widget build(BuildContext context) {
    return RoundButton(
      onPressed: onPressed, 
      text: text, 
      widthRatio: widthRatio,
      borderColor: Theme.of(context).primaryColor,
      fontSizeFactor: this.fontSizeFactor,
      textColor: Theme.of(context).primaryColor,
    );
  }}

class RoundButton extends StatelessWidget {

  final String text;
  final void Function()? onPressed;
  final double widthRatio;
  final double fontSizeFactor;
  final LinearGradient? gradient;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;

  const RoundButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.widthRatio,
    required this.textColor,
    this.gradient,
    this.backgroundColor,
    this.borderColor,
    this.fontSizeFactor = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenWidth * widthRatio * 0.25,
      width: screenWidth * widthRatio,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: borderColor == null ? null : Border.all(
          color: borderColor!
        ),
        gradient: gradient
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        onPressed: onPressed, 
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            color: textColor,
            fontFamily: "Roboto",
            fontStyle: FontStyle.normal,
            fontSize: screenWidth * widthRatio * 0.1 * fontSizeFactor
          ),
          textAlign: TextAlign.center,
        )
      ),
    );
  }
}