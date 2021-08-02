import 'package:flutter/widgets.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIcon.dart';

abstract class SelectableTile {
  CategoryIcon? get icon;
  Text get title;
  Text get rightText;
  Text get secondaryTitle;
}
