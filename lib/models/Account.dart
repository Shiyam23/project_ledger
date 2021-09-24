import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import 'package:project_ez_finance/components/categoryIcon/CategoryIcon.dart';

part 'Account.g.dart';

@HiveType(typeId: 6)
class Account extends Equatable {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final CategoryIcon icon;
  @HiveField(2)
  final bool selected;
  @HiveField(3)
  final String currencyCode;

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
  List<Object?> get props => [name, icon.iconData, currencyCode];

  Account copyWith({
    String? name,
    CategoryIcon? icon,
    bool? selected,
    String? currencyCode,
  }) {
    return Account(
      name: name ?? this.name,
      icon: icon ?? this.icon,
      selected: selected ?? this.selected,
      currencyCode: currencyCode ?? this.currencyCode,
    );
  }
}
