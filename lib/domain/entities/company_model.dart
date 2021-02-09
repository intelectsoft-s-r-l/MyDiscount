import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'company_model.g.dart';

@HiveType(typeId: 2)
class Company {
  @HiveField(0)
  final String amount;
  @HiveField(1)
  final int id;
  @HiveField(2)
  final Uint8List logo;
  @HiveField(3)
  final String name;
  Company({
    @required this.amount,
    @required this.id,
    @required this.logo,
    @required this.name,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
        amount: json['Amount'] as String,
        id: json['ID'] as int,
        logo: json['Logo'] as Uint8List,
        name: json['Name'] as String);
  }
}
