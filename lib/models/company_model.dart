import 'dart:typed_data';

import 'package:flutter/foundation.dart';




class Company {

  final String amount;

  final int id;
  
  final Uint8List logo;

  final String name;
  Company({
    @required this.amount,
    @required this.id,
    @required this.logo,
    @required this.name,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
        amount: json['Amount'],
        id: json['ID'],
        logo: json['Logo'],
        name: json['Name']);
  }
}
