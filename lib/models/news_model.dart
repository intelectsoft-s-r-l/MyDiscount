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
        appType: json['AppType'],
        companyId: json['CompanyID'],
        companyName: json['CompanyName'],
        content: json['Content'],
        dateTime: json['CreateDate'],
        header: json['Header'],
        id: json['ID'],
        photo: json['Photo'] ?? Uint8List.fromList([]),
        logo: json['Logo'] ?? Uint8List.fromList([]));
  }
}
