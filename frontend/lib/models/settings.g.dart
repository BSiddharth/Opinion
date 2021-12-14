// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsAdapter extends TypeAdapter<Settings> {
  @override
  final int typeId = 0;

  @override
  Settings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Settings(
      disableAllNotifBool: fields[0] as dynamic,
      commentNotifBool: fields[1] as dynamic,
      replyNotifBool: fields[2] as dynamic,
      voteNotifBool: fields[3] as dynamic,
      mentionNotifBool: fields[4] as dynamic,
      showOptionsBool: fields[5] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, Settings obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.disableAllNotifBool)
      ..writeByte(1)
      ..write(obj.commentNotifBool)
      ..writeByte(2)
      ..write(obj.replyNotifBool)
      ..writeByte(3)
      ..write(obj.voteNotifBool)
      ..writeByte(4)
      ..write(obj.mentionNotifBool)
      ..writeByte(5)
      ..write(obj.showOptionsBool);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
