import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';

part 'CategoryIconData.g.dart';

@HiveType(typeId: 1)
class CategoryIconData {
  @HiveField(0)
  final int backgroundColorInt;
  final Color backgroundColor;

  @HiveField(1)
  final String iconName;
  final IconData icon;

  @HiveField(2)
  final int iconColorInt;
  final Color iconColor;

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
    "subscription": FontAwesomeIcons.bell,
    "suitcaseRolling": FontAwesomeIcons.suitcaseRolling,
    "pen": FontAwesomeIcons.pen
  };

  CategoryIconData(
      {this.backgroundColor, this.iconName, this.iconColor = Colors.white})
      : this.backgroundColorInt = backgroundColor.value,
        this.iconColorInt = iconColor.value,
        this.icon = iconList[iconName];
}
