import 'dart:typed_data';

import 'package:equatable/equatable.dart';
/// Dart object for Transaction data provided by back service
///
/// Utilise this class to representing on UI a list of transaction  performed by 
/// User in MyDiscount service

class Transaction extends Equatable{
  /// The amount of transaction
  final num amount;
  /// Company where User efectuating a transaction
  final String company;
  /// Date of transaction
  final String dateOfSale;
  /// Transaction address
  final String salesPoint;
  /// Company logo
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
