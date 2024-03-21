// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Recording.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecordingAdapter extends TypeAdapter<Recording> {
  @override
  final int typeId = 0;

  @override
  Recording read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Recording(
      fields[0] as int,
      fields[1] as int,
      fields[2] as int,
      fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Recording obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.systolic)
      ..writeByte(1)
      ..write(obj.diastolic)
      ..writeByte(2)
      ..write(obj.pulse)
      ..writeByte(3)
      ..write(obj.dateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecordingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
