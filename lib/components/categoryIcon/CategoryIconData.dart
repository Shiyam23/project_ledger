import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';

part 'CategoryIconData.g.dart';

@HiveType(typeId: 1)
class CategoryIconData {
  @HiveField(0)
  final String backgroundColorName;
  final Color backgroundColor;

  @HiveField(1)
  final String iconName;
  final IconData icon;

  @HiveField(2)
  final String iconColorName;
  final Color iconColor;

  static const Map<String, Color> colorList = {
    "white": Colors.white,
    "grey": Colors.grey,
    "black": Colors.black,
    "red": Colors.red,
    "orange": Colors.orange,
    "yellow": Colors.yellow,
    "green": Colors.green,
    "lightGreen": Colors.lightGreen,
    "blue": Colors.blue,
    "lightBlue": Colors.lightBlue,
    "purple": Colors.purple,
    "pink": Colors.pink,
    "teal": Colors.teal
  };

  static const Map<String, IconData> iconList = {
    "shopping": FontAwesomeIcons.shoppingBag,
    "food": FontAwesomeIcons.utensils,
    "hobby": FontAwesomeIcons.running,
    "communication": FontAwesomeIcons.comment,
    "vehicle": FontAwesomeIcons.car,
    "salary": FontAwesomeIcons.handHoldingUsd,
    "rent": FontAwesomeIcons.home,
    "others": FontAwesomeIcons.ellipsisH,
    "insurance": FontAwesomeIcons.houseDamage,
    "pet": FontAwesomeIcons.paw,
    "subscription": FontAwesomeIcons.bell
  };

  CategoryIconData(
      {this.backgroundColorName, this.iconName, this.iconColorName = "white"})
      : this.backgroundColor = colorList[backgroundColorName],
        this.iconColor = colorList[iconColorName],
        this.icon = iconList[iconName];
}
