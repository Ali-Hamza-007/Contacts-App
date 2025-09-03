//import 'dart:io';

import 'package:hive/hive.dart';

import 'package:hive_flutter/hive_flutter.dart';
part 'contact_attributes.g.dart';

@HiveType(typeId: 0)
class ContactAttributes {
  @HiveField(0)
  String? name;
  @HiveField(1)
  String contactNumber;
  @HiveField(2)
  String? imageAddress;

  ContactAttributes({
    required this.name,
    required this.contactNumber,
    required this.imageAddress,
  });
}
