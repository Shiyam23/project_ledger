import 'package:flutter/material.dart';

class EmptyNotification extends StatelessWidget {

  final String title;
  final String information;

  const EmptyNotification({
    Key? key,
    required this.title,
    required this.information
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      padding: const EdgeInsets.all(25.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(Icons.info),
              color: Theme.of(context).primaryColor,
              iconSize: MediaQuery.of(context).size.height * 0.03,
              onPressed: () => _showInformation(context),
            )
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 4,
            child: Image.asset("assets/icons/box2.png")
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 40),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).primaryColor
            )
          )
        ],
      ),
    );
  }

  void _showInformation(BuildContext context) async {
    await showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        title: Text(title),
        content: Text(
          information,
          textAlign: TextAlign.justify,
        ),
      )
    );
  }
}