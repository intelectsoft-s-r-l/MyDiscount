// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NewsAdapter extends TypeAdapter<News> {
  @override
  final int typeId = 1;

  @override
  News read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return News(
      companyName: fields[2] as String,
      appType: fields[0] as int,
      companyId: fields[1] as int,
      content: fields[3] as String,
      dateTime: fields[4] as String,
      header: fields[6] as String,
      id: fields[5] as int,
      photo: fields[7] as Uint8List,
      logo: fields[8] as Uint8List,
    );
  }

  @override
  void write(BinaryWriter writer, News obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.appType)
      ..writeByte(1)
      ..write(obj.companyId)
      ..writeByte(2)
      ..write(obj.companyName)
      ..writeByte(3)
      ..write(obj.content)
      ..writeByte(4)
      ..write(obj.dateTime)
      ..writeByte(5)
      ..write(obj.id)
      ..writeByte(6)
      ..write(obj.header)
      ..writeByte(7)
      ..write(obj.photo)
      ..writeByte(8)
      ..write(obj.logo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
