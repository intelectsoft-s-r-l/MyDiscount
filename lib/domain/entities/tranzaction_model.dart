import 'dart:typed_data';

import 'package:flutter/foundation.dart';

class Transaction {
  final num amount;
  final String company;
  final String dateOfSale;
  final String salesPoint;
  final Uint8List logo;

  Transaction({
    @required this.amount,
    @required this.company,
    @required this.dateOfSale,
    @required this.salesPoint,
    @required this.logo,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      amount: json['Amount']as num,
      company: json['Company']as String,
      dateOfSale: json['DateTimeOfSale']as String,
      salesPoint: json['SalesPoint']as String,
      logo: json['Logo']as Uint8List ?? Uint8List.fromList([]),
    );
  }
}
