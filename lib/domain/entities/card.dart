import 'dart:typed_data';

import 'package:flutter/foundation.dart';

class DiscountCard {
  final String code;
  final String companyName;
  final int status;
  final Uint8List companyLogo;

  DiscountCard({
    @required this.code,
    @required this.companyName,
    @required this.status,
    @required this.companyLogo,
  });
  factory DiscountCard.fromJson(Map<String, dynamic> json) {
    return DiscountCard(
      code: json['Code'],
      companyLogo: json['Logo'],
      companyName: json['Company'],
      status: json['State'],
    );
  }
  DiscountCard copyWith({
    String code,
    String companyName,
    int status,
    Uint8List companyLogo,
  }) {
    return DiscountCard(
      code: code ?? this.code,
      companyName: companyName ?? this.companyName,
      status: status ?? this.status,
      companyLogo: companyLogo ?? this.companyLogo,
    );
  }
}
