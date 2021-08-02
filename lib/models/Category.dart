import 'package:hive/hive.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIcon.dart';

part 'Category.g.dart';

@HiveType(typeId: 2)
class Category {
  @HiveField(0)
  String? name;
  @HiveField(1)
  CategoryIcon? icon;

  Category({this.name, this.icon});
}
