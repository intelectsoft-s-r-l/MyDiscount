import 'dart:typed_data';

import 'package:equatable/equatable.dart';
/// Dart object for Discount cards provided by back service
/// 
/// Utilize this class for representing on UI a list of real Discount cards 
/// activated by user on `MyDiscount` service
class DiscountCard extends Equatable {
  /// Card unique code
  final String code;
  /// Company which emit this card
  final String companyName;
  /// The status of card in our system
  final int status;
  /// Company logo as `bytes` 
  final Uint8List companyLogo;

  DiscountCard({
    required this.code,
    required this.companyName,
    required this.status,
    required this.companyLogo,
  });
  factory DiscountCard.fromJson(Map<String, dynamic> json) {
    return DiscountCard(
      code: json['Code'],
      companyLogo: json['Logo'] as Uint8List,
      companyName: json['Company'],
      status: json['State'] ,
    );
  }
  DiscountCard copyWith({
    String? code,
    String? companyName,
    int? status,
    Uint8List? companyLogo,
  }) {
    return DiscountCard(
      code: code ?? this.code,
      companyName: companyName ?? this.companyName,
      status: status ?? this.status,
      companyLogo: companyLogo ?? this.companyLogo,
    );
  }

  @override
  List<Object?> get props => [];
}
