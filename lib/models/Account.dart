import 'package:hive/hive.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIcon.dart';

part 'Account.g.dart';

@HiveType(typeId: 6)
class Account {
  @HiveField(0)
  String name;
  @HiveField(1)
  CategoryIcon icon;

  Account({required this.name, required this.icon});

  @override
  String toString() {
    return this.name;
  }
}
