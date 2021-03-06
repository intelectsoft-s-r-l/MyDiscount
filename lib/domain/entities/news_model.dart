import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import 'package:hive/hive.dart';

part 'news_model.g.dart';

@HiveType(typeId: 1)
class News {
  @HiveField(0)
  final int appType;
  @HiveField(1)
  final int companyId;
  @HiveField(2)
  final String companyName;
  @HiveField(3)
  final String content;
  @HiveField(4)
  final String dateTime;
  @HiveField(5)
  final int id;
  @HiveField(6)
  final String header;
  @HiveField(7)
  final Uint8List photo;
  @HiveField(8)
  final Uint8List logo;

  News({
    @required this.companyName,
    @required this.appType,
    @required this.companyId,
    @required this.content,
    @required this.dateTime,
    @required this.header,
    @required this.id,
    @required this.photo,
    @required this.logo,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      appType: json['AppType']as int,
      companyId: json['CompanyID']as int,
      companyName: json['CompanyName']as String,
      content: json['Content'] as String,
      dateTime: json['CreateDate']as String,
      header: json['Header']as String,
      id: json['ID']as int,
      photo: json['Photo']as Uint8List ?? Uint8List.fromList([]) ,
      logo: json['CompanyLogo'] as Uint8List ?? Uint8List.fromList([]),
    );
  }
  News copyWith({
    int appType,
    int companyId,
    String companyName,
    String content,
    String dateTime,
    int id,
    String header,
    Uint8List photo,
    Uint8List logo,
  }) {
    return News(
      appType: appType ?? this.appType,
      companyId: companyId ?? this.companyId,
      companyName: companyName ?? this.companyName,
      content: content ?? this.content,
      dateTime: dateTime ?? this.dateTime,
      id: id ?? this.id,
      header: header ?? this.header,
      photo: photo ?? this.photo,
      logo: logo ?? this.logo,
    );
  }
}
