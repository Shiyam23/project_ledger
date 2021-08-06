// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CategoryIcon.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategoryIconAdapter extends TypeAdapter<CategoryIcon> {
  @override
  final int typeId = 0;

  @override
  CategoryIcon read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
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

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryIconAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
