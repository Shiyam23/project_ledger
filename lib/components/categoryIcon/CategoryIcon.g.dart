// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CategoryIcon.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategoryIconAdapter extends TypeAdapter<CategoryIcon> {
  @override
  final typeId = 0;

  @override
  CategoryIcon read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CategoryIcon(
      iconData: fields[0] as CategoryIconData,
    );
  }

  @override
  void write(BinaryWriter writer, CategoryIcon obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.iconData);
  }
}
