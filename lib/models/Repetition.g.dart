// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Repetition.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CalenderUnitAdapter extends TypeAdapter<CalenderUnit> {
  @override
  final typeId = 5;

  @override
  CalenderUnit read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CalenderUnit.dayly;
      case 1:
        return CalenderUnit.monthly;
      case 2:
        return CalenderUnit.yearly;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, CalenderUnit obj) {
    switch (obj) {
      case CalenderUnit.dayly:
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
}

class RepetitionAdapter extends TypeAdapter<Repetition> {
  @override
  final typeId = 4;

  @override
  Repetition read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Repetition(
      amount: fields[0] as int,
      time: fields[1] as CalenderUnit,
      endDate: fields[2] as DateTime,
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
}
