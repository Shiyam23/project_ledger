import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import 'package:dollavu/components/categoryIcon/CategoryIcon.dart';

part 'Category.g.dart';

@HiveType(typeId: 2)
class Category extends Equatable {
  @HiveField(0)
  final String? name;
  @HiveField(1)
  final CategoryIcon? icon;

  Category({this.name, this.icon});

  @override
  List<Object?> get props => [name, icon?.iconData];

  Category copyWith({
    String? name,
    CategoryIcon? icon,
  }) {
    return Category(
      name: name ?? this.name,
      icon: icon ?? this.icon,
    );
  }
}
