// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveLocationDataAdapter extends TypeAdapter<HiveLocationData> {
  @override
  final int typeId = 0;

  @override
  HiveLocationData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveLocationData(
      firstplaceLat: fields[0] as double,
      firstplaceLong: fields[1] as double,
      firstPlaceAddress: fields[2] as String,
      secondPlaceLat: fields[3] as double,
      secondPlaceLong: fields[4] as double,
      secondPlaceAddress: fields[5] as String,
      distance: fields[6] as double,
      timeStamp: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HiveLocationData obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.firstplaceLat)
      ..writeByte(1)
      ..write(obj.firstplaceLong)
      ..writeByte(2)
      ..write(obj.firstPlaceAddress)
      ..writeByte(3)
      ..write(obj.secondPlaceLat)
      ..writeByte(4)
      ..write(obj.secondPlaceLong)
      ..writeByte(5)
      ..write(obj.secondPlaceAddress)
      ..writeByte(6)
      ..write(obj.distance)
      ..writeByte(7)
      ..write(obj.timeStamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveLocationDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ListofLocationAdapter extends TypeAdapter<ListofLocation> {
  @override
  final int typeId = 1;

  @override
  ListofLocation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ListofLocation(
      locationList: (fields[0] as List).cast<HiveLocationData>(),
    );
  }

  @override
  void write(BinaryWriter writer, ListofLocation obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.locationList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListofLocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
