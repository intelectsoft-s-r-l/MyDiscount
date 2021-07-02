import 'dart:typed_data';

import 'package:hive/hive.dart';

part 'news_model.g.dart';
/// Dart object for News provided by back service
///
/// Utilise this class for representing on UI a list of News generated in
/// Client Portal from Owner of account 

@HiveType(typeId: 1)
class News {
  /// This field is'nt used at this moment in MyDiscount application
  @HiveField(0)
  final int appType;
  /// The ID of Company who created this news 
  @HiveField(1)
  final int companyId;
  /// Company name who created this news
  @HiveField(2)
  final String companyName;
  /// News content as HTML string (need to parse to flutter widget) to display 
  /// on UI
  @HiveField(3)
  final String content;
  /// News creation date
  @HiveField(4)
  final String dateTime;
  /// News id 
  @HiveField(5)
  final int id;
  /// News header as HTML string (need to parse to flutter widget) to display 
  /// on UI
  @HiveField(6)
  final String header;
  ///The Image added to News when is generated on Client Portal
  @HiveField(7)
  final Uint8List photo;
  ///The logo of company who generate News
  @HiveField(8)
  final Uint8List logo;

  News({
    required this.companyName,
    required this.appType,
    required this.companyId,
    required this.content,
    required this.dateTime,
    required this.header,
    required this.id,
    required this.photo,
    required this.logo,
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
      photo: json['Photo'] ?? Uint8List.fromList([]) ,
      logo: json['CompanyLogo'] ?? Uint8List.fromList([]),
    );
  }
  News copyWith({
    int? appType,
    int? companyId,
    String? companyName,
    String? content,
    String? dateTime,
    int? id,
    String? header,
    Uint8List? photo,
    Uint8List? logo,
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
