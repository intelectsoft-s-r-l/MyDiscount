import 'package:flutter/foundation.dart';

class Transaction {
  final num amount;
  final String company;
  final String dateOfSale;
  final String salesPoint;

  Transaction({
    @required this.amount,
    @required this.company,
    @required this.dateOfSale,
    @required this.salesPoint,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      amount: json['Amount'],
      company: json['Company'],
      dateOfSale: json['DateTimeOfSale'],
      salesPoint: json['SalesPoint'],
    );
  }
}
