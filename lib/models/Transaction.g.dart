// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Transaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionAdapter extends TypeAdapter<Transaction> {
  @override
  final int typeId = 3;

  @override
  Transaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Transaction(
      name: fields[0] as dynamic,
      category: fields[2] as dynamic,
      date: fields[1] as dynamic,
      amount: fields[3] as dynamic,
      isExpense: fields[4] as dynamic,
      repetition: fields[5] as dynamic,
      account: fields[6] as dynamic,
      addDateTime: fields[7] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, Transaction obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.amount)
      ..writeByte(4)
      ..write(obj.isExpense)
      ..writeByte(5)
      ..write(obj.repetition)
      ..writeByte(6)
      ..write(obj.account)
      ..writeByte(7)
      ..write(obj.addDateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
