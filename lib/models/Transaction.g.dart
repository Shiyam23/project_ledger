// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Transaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionAdapter extends TypeAdapter<Transaction> {
  @override
  final typeId = 4;

  @override
  Transaction read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Transaction(
      name: fields[0] as String,
      category: fields[5] as Dollavu.Category,
      date: fields[1] as DateTime,
      icon: fields[2] as CategoryIcon,
      amount: fields[3] as String,
      isExpense: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Transaction obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.icon)
      ..writeByte(3)
      ..write(obj.amount)
      ..writeByte(4)
      ..write(obj.isExpense)
      ..writeByte(5)
      ..write(obj.category);
  }
}
