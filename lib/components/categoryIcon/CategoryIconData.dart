import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';

part 'CategoryIconData.g.dart';

@HiveType(typeId: 1)
class CategoryIconData {
  @HiveField(0)
  final int? backgroundColorInt;

  @HiveField(1)
  final String? iconName;
  final IconData? icon;

  @HiveField(2)
  final int? iconColorInt;

  static const Map<String, IconData> iconList = {
    "home": FontAwesomeIcons.home,
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
      {this.backgroundColorInt, this.iconName, this.iconColorInt})
      : this.icon = iconList[iconName!];
}
