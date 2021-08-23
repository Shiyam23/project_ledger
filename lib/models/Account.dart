import 'package:currency_picker/currency_picker.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:project_ez_finance/components/categoryIcon/CategoryIcon.dart';

part 'Account.g.dart';

@HiveType(typeId: 6)
class Account extends Equatable{
  @HiveField(0)
  String name;
  @HiveField(1)
  CategoryIcon icon;
  @HiveField(2)
  bool selected;
  @HiveField(3)
  String currencyCode;

  Account({
    required this.name, 
    required this.icon,
    required this.selected,
    required this.currencyCode,
  });

  @override
  String toString() {
    return this.name;
  }

  @override
  List<Object?> get props => [name, icon.iconData];
}
