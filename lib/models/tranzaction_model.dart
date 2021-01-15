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
      amount: json['Amount'],
      company: json['Company'],
      dateOfSale: json['DateTimeOfSale'],
      salesPoint: json['SalesPoint'],
      logo: json['Logo'] ?? Uint8List.fromList([]),
    );
  }
}
