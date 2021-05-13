import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class Transaction extends Equatable{
  final num amount;
  final String company;
  final String dateOfSale;
  final String salesPoint;
  final Uint8List logo;

  Transaction({
    required this.amount,
    required this.company,
    required this.dateOfSale,
    required this.salesPoint,
    required this.logo,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      amount: json['Amount']as num,
      company: json['Company']as String,
      dateOfSale: json['DateTimeOfSale']as String,
      salesPoint: json['SalesPoint']as String,
      logo: json['Logo'] ?? Uint8List.fromList([]),
    );
  }

  @override

  List<Object?> get props => [];
}
