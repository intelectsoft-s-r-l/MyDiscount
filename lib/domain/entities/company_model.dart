import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'company_model.g.dart';
/// Dart object for Company data provided by back service
/// 
/// Utilize this class for representing on UI a list of Company who is connected
/// to MyDiscount service and the sum  of all discount collected from user on 
/// that Company 
@HiveType(typeId: 2)
class Company extends Equatable {
  /// Total discount of user in this company
  @HiveField(0)
  final String amount;
  /// Company id 
  @HiveField(1)
  final int id;
  ///Company logo
  @HiveField(2)
  final Uint8List logo;
  ///Company name
  @HiveField(3)
  final String name;
  Company({
    required this.amount,
    required this.id,
    required this.logo,
    required this.name,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      amount: json['Amount'] as String,
      id: json['ID'] as int,
      logo: json['Logo'] as Uint8List,
      name: json['Name'] as String,
    );
  }

  @override
  List<Object?> get props => [];
}
