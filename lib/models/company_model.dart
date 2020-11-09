import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Company extends Equatable {
  final String amount;
  final int id;
  final String logo;
  final String name;

  Company({
    @required this.amount,
    @required this.id,
    @required this.logo,
    @required this.name,
  });
  @override
  List<Object> get props => [amount, id, logo, name];
}

class CompanyModel extends Company {
  CompanyModel({
    @required String amount,
    @required int id,
    @required String logo,
    @required String name,
  }) : super(
          amount: amount,
          id: id,
          logo: logo,
          name: name,
        );

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
        amount: json['Amount'],
        id: json['ID'],
        logo: json['Logo'],
        name: json['Name']);
  }
}

/* class ListOfCompany {
  final List<Company> list;

  ListOfCompany(this.list);
  addtoList() => list.add(Company(amount: ));
} */
