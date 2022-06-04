import 'package:flutter/material.dart';

class RoundGradientButton extends StatelessWidget {

  final String text;
  final void Function()? onPressed;

  const RoundGradientButton({
    Key? key,
    required this.onPressed,
    required this.text,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed, 
      child:Ink(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromRGBO(56, 100, 132, 0.75),
            Color.fromRGBO(56, 100, 132, 1),
          ]),
          borderRadius: BorderRadius.all(Radius.circular(80.0)),
        ),
        child: Container(
          width: 150,
          constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
          alignment: Alignment.center,
          child: const Text(
            'SAVE',
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Roboto",
              fontStyle: FontStyle.normal,
            ),
            textAlign: TextAlign.center,
          ),
        )
      )
    );
  }
}

class RoundButton extends StatelessWidget {

  final String text;
  final void Function()? onPressed;

  const RoundButton({
    Key? key,
    required this.onPressed,
    required this.text,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed, 
      child:Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(80.0)),
          border: Border.all(color: Colors.black)
        ),
        child: Container(
          width: 150,
          constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
          alignment: Alignment.center,
          child: const Text(
            'RESET',
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Roboto",
              fontStyle: FontStyle.normal,
            ),
            textAlign: TextAlign.center,
          ),
        )
      )
    );
  }
}