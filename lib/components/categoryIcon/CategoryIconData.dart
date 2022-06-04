import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';

part 'CategoryIconData.g.dart';

@HiveType(typeId: 1)
class CategoryIconData extends Equatable{
  @HiveField(0)
  final int? backgroundColorInt;

  @HiveField(1)
  final String? iconName;
  final IconData? icon;

  @HiveField(2)
  final int? iconColorInt;

  static const Map<String, IconData> iconList = {
    "home": FontAwesomeIcons.house,
    "shopping": FontAwesomeIcons.bagShopping,
    "food": FontAwesomeIcons.utensils,
    "hobby": FontAwesomeIcons.personRunning,
    "communication": FontAwesomeIcons.comment,
    "vehicle": FontAwesomeIcons.car,
    "salary": FontAwesomeIcons.handHoldingDollar,
    "rent": FontAwesomeIcons.house,
    "others": FontAwesomeIcons.ellipsis,
    "insurance": FontAwesomeIcons.houseChimneyCrack,
    "pet": FontAwesomeIcons.paw,
    "subscription": FontAwesomeIcons.bell,
    "suitcaseRolling": FontAwesomeIcons.suitcaseRolling,
    "pen": FontAwesomeIcons.pen,
  };

  static List<int> colorList = 
    Colors.primaries.map((color) => color[900]!.value).toList();

  CategoryIconData(
      {this.backgroundColorInt, this.iconName, this.iconColorInt})
      : this.icon = iconList[iconName];

  @override
  List<Object?> get props => [iconName, backgroundColorInt, iconColorInt];
}
