// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CategoryIconData.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategoryIconDataAdapter extends TypeAdapter<CategoryIconData> {
  @override
  final typeId = 1;

  @override
  CategoryIconData read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CategoryIconData(
      backgroundColorName: fields[0] as String,
      iconName: fields[1] as String,
      iconColorName: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CategoryIconData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.backgroundColorName)
      ..writeByte(1)
      ..write(obj.iconName)
      ..writeByte(2)
      ..write(obj.iconColorName);
  }
}
