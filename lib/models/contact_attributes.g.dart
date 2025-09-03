// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_attributes.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContactAttributesAdapter extends TypeAdapter<ContactAttributes> {
  @override
  final int typeId = 0;

  @override
  ContactAttributes read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ContactAttributes(
      name: fields[0] as String?,
      contactNumber: fields[1] as String,
      imageAddress: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ContactAttributes obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.contactNumber)
      ..writeByte(2)
      ..write(obj.imageAddress);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContactAttributesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
