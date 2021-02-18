import 'dart:convert';

import 'package:MyDiscount/domain/entities/company_model.dart';
import 'package:MyDiscount/services/shared_preferences_service.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import '../domain/entities/user_model.dart';
import '../domain/entities/profile_model.dart';
import '../domain/entities/news_model.dart';
import '../domain/repositories/local_repository.dart';

@injectable
class LocalRepositoryImpl implements LocalRepository {
  final Box<User> userBox;
  final Box<Profile> profileBox;
  final Box<News> newsBox;
  final Box<Company> companyBox;
  final SharedPref _prefs;

  LocalRepositoryImpl(this.userBox, this.profileBox, this.newsBox, this.companyBox, this._prefs);
  @override
  Future<Profile> getLocalClientInfo() async {
    return profileBox?.get(1);
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
    return userBox?.get(1);
  }

  @override
  void saveLocalClientInfo(Profile profile) {
    profileBox?.put(1, profile);
  }

  @override
  void saveLocalNews(List newsList) {
    newsList.map((e) => News.fromJson(e)).toList().forEach((news) => newsBox?.put(news.id, news));
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
  void saveLocalCompanyList(List list) {
    list.map((company) => Company.fromJson(company)).toList().forEach((company) => companyBox.put(company.id, company));
  }

  returnUserMapToSave(Map<String, dynamic> json) {
    final Map<String, dynamic> userMap = {};
    final keys = json.keys;
    for (String key in keys) {
      if (key == 'ID' || key == 'RegisterMode' || key == 'access_token') {
        userMap.putIfAbsent(key, () => json[key]);
      }
    }
    return userMap;
  }

  Future<Map<String, dynamic>> getFacebookProfile(String token) async {
    final _graphResponse = await http.get('https://graph.facebook.com/v2.6/me?fields=id,name,picture,email&access_token=$token');
    return json.decode(_graphResponse.body) as Map<String, dynamic>;
  }

  @override
  void deleteLocalUser() {
    userBox.delete(1);
    profileBox.delete(1);
  }

  Future<bool> smsCodeVerification(VerificationCode code) async {
    try {
      final codeFromServer = await _prefs.readCode();
      if (code == VerificationCode(codeFromServer)) {
        _prefs.remove('code');
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}

class VerificationCode {
  final String code;

  const VerificationCode(this.code);

  int get lenght => code.length;
  @override
  bool operator ==(Object other) {
    return identical(this, other) || other is VerificationCode && code == other.code;
  }

  @override
  int get hashCode => code.hashCode;
}
