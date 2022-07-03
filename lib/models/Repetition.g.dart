// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Repetition.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RepetitionAdapter extends TypeAdapter<Repetition> {
  @override
  final int typeId = 4;

  @override
  Repetition read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Repetition(
      amount: fields[0] as int?,
      time: fields[1] as CalenderUnit?,
      endDate: fields[2] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Repetition obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.amount)
      ..writeByte(1)
      ..write(obj.time)
      ..writeByte(2)
      ..write(obj.endDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RepetitionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CalenderUnitAdapter extends TypeAdapter<CalenderUnit> {
  @override
  final int typeId = 5;

  @override
  CalenderUnit read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CalenderUnit.daily;
      case 1:
        return CalenderUnit.monthly;
      case 2:
        return CalenderUnit.yearly;
      default:
        return CalenderUnit.daily;
    }
  }

  @override
  void write(BinaryWriter writer, CalenderUnit obj) {
    switch (obj) {
      case CalenderUnit.daily:
        writer.writeByte(0);
        break;
      case CalenderUnit.monthly:
        writer.writeByte(1);
        break;
      case CalenderUnit.yearly:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalenderUnitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
