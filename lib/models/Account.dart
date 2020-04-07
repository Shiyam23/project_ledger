import 'package:project_ez_finance/components/categoryIcon/CategoryIcon.dart';

class Account {
  String name;
  CategoryIcon icon;

  Account({this.name, this.icon});

  @override
  String toString() {
    return this.name;
  }
}
