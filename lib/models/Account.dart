import 'package:hive/hive.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIcon.dart';

part 'Account.g.dart';

@HiveType(typeId: 6)
class Account {
  String? name;
  CategoryIcon? icon;

  Account({this.name, this.icon});

  @override
  String toString() {
    return this.name!;
  }
}
