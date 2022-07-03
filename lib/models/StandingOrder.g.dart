// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'StandingOrder.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StandingOrderAdapter extends TypeAdapter<StandingOrder> {
  @override
  final int typeId = 7;

  @override
  StandingOrder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StandingOrder(
      initialTransaction: fields[0] as Transaction,
      totalAmount: fields[1] as double,
      nextDueDate: fields[2] as DateTime,
      totalTransactions: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, StandingOrder obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.initialTransaction)
      ..writeByte(1)
      ..write(obj.totalAmount)
      ..writeByte(2)
      ..write(obj.nextDueDate)
      ..writeByte(3)
      ..write(obj.totalTransactions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StandingOrderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
