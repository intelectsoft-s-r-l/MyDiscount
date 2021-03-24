import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import '../domain/entities/company_model.dart';
import '../domain/entities/news_model.dart';
import '../domain/entities/profile_model.dart';
import '../domain/entities/user_model.dart';
import '../domain/repositories/local_repository.dart';

@LazySingleton(as: LocalRepository)
class LocalRepositoryImpl implements LocalRepository {
  final Box<User> userBox;
  final Box<Profile> profileBox;
  final Box<News> newsBox;
  final Box<Company> companyBox;

  LocalRepositoryImpl(
    this.userBox,
    this.profileBox,
    this.newsBox,
    this.companyBox,
  );
  @override
  Profile getLocalClientInfo() {
    if (profileBox.isNotEmpty) {
      return profileBox?.get(1);
    } else {
      return Profile.empty();
    }
  }

  @override
  List<News> getLocalNews() {
    try {
      List<News> newsList = [];
      final keys = newsBox?.keys;
      for (int key in keys) {
        final news = newsBox?.get(key);
        newsList.add(news);
      }
      return newsList.reversed?.toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  User getLocalUser() {
    final User _user = userBox?.get(1);
    return _user;
  }

  @override
  Profile saveLocalClientInfo(Profile profile) {
    profileBox?.put(1, profile);
    return profile;
  }

  @override
  void saveLocalNews(List newsList) {
    newsList
        .map((e) => News.fromJson(e))
        .toList()
        .forEach((news) => newsBox?.put(news.id, news));
  }

  @override
  User saveLocalUser(User user) {
    userBox?.put(1, user);
    return user;
  }

  @override
  String readEldestNewsId() {
    final listOfKeys = newsBox?.keys;

    int id = 0;
    if (listOfKeys.isNotEmpty) {
      for (final int key in listOfKeys) {
        if (key > id) {
          id = key;
        }
      }
    }

    return id.toString();
  }

  @override
  void saveLocalCompanyList(List<Company> list) {
    list.map((company) => companyBox.put(company.id, company));
  }
  @override
  Map<String, dynamic> returnUserMapToSave(Map<String, dynamic> json) {
    final  userMap =<String,dynamic> {};
    final keys = json.keys;
    for (final key in keys) {
      if (key == 'ID' || key == 'RegisterMode' || key == 'access_token') {
        userMap.putIfAbsent(key, () => json[key]);
      }
    }
    return userMap;
  }
  @override
  Future<Map<String, dynamic>> getFacebookProfile(String token) async {
    final _graphResponse = await http.get(Uri.parse(
        'https://graph.facebook.com/v2.6/me?fields=id,name,picture,email&access_token=$token'));
    return json.decode(_graphResponse.body) as Map<String, dynamic>;
  }

  @override
  void deleteLocalUser() {
    userBox.delete(1);
    profileBox.delete(1);
  }
  @override
  bool smsCodeVerification(String serverCode, String userCode) {
    try {
      if (VerificationCode(serverCode) == VerificationCode(userCode)) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  @override
  Future<List<Company>> getCachedCompany() async {
    try {
      final keys = companyBox.keys;
      final list = <Company>[];
      if (companyBox.isNotEmpty) {
        for (int key in keys) {
          list.add(companyBox.get(key));
        }
      }
      return list;
    } catch (e) {
      rethrow;
    }
  }
  @override
  Future<Map<String, dynamic>> returnProfileMapDataAsMap(
      Profile profile) async {
    final user = userBox.get(1);
    final result = await testComporessList(profile.photo);
    print(result);
    return {
      'DisplayName': '${profile.firstName} ${profile.lastName}',
      'Email': profile.email,
      'ID': user.id,
      'phone': profile.phone,
      'PhotoUrl': base64Encode(result.toList()),
      'PushToken': '',
      'RegisterMode': user.registerMode,
      'access_token': user.accessToken,
    };
  }

  Future<Uint8List> testComporessList(Uint8List list) async {
    final result = await FlutterImageCompress.compressWithList(
      list,
      minHeight: 110,
      minWidth: 110,
      quality: 100,
      rotate: 0,
      format: CompressFormat.jpeg,
    );
    return result;
  }
}

class VerificationCode {
  final String code;

  const VerificationCode(this.code);

  int get lenght => code.length;
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is VerificationCode && code == other.code;
  }

  @override
  int get hashCode => code.hashCode;
}
