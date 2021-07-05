import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import '../domain/entities/company_model.dart';
import '../domain/entities/news_model.dart';
import '../domain/entities/profile_model.dart';
import '../domain/entities/user_model.dart';
import '../domain/repositories/local_repository.dart';
import 'core/failure.dart';

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
    try {
      if (profileBox.isNotEmpty) {
        return profileBox.get(1) as Profile;
      } else {
        return Profile.empty();
      }
    } catch (e) {
      throw LocalCacheError();
    }
  }

  @override
  Stream<Profile> updateClientInfo() async* {
    yield profileBox.watch() as Profile;
  }

  @override
  List<News> getLocalNews() {
    try {
      final newsList = <News>[];
      final keys = newsBox.keys;
      for (int key in keys) {
        final news = newsBox.get(key) as News;

        newsList.add(news);
      }
      return newsList.reversed.toList();
    } catch (e) {
      throw LocalCacheError();
    }
  }

  @override
  User getLocalUser() {
    try {
      if (userBox.isNotEmpty) {
        final _user = userBox.get(1) as User;
        return _user;
      }
      return User.empty();
    } catch (e) {
      throw LocalCacheError();
    }
  }

  @override
  void saveClientInfoLocal(Profile profile) {
    try {
      profileBox.put(1, profile);
    } catch (e) {
      throw LocalCacheError();
    }
  }

  @override
  void saveNewsLocal(List newsList) {
    try {
      newsList
          .map((e) => News.fromJson(e))
          .toList()
          .forEach((news) => newsBox.put(news.id, news));
    } catch (e) {
      throw LocalCacheError();
    }
  }

  @override
  void saveUserLocal(User user) {
    try {
      userBox.put(1, user);
    } catch (e) {
      throw LocalCacheError();
    }
  }

  @override
  String readEldestNewsId() {
    try {
      final listOfKeys = newsBox.keys;

      var id = 0;
      if (listOfKeys.isNotEmpty) {
        for (final int key in listOfKeys) {
          if (key > id) {
            id = key;
          }
        }
      }

      return id.toString();
    } catch (e) {
      throw LocalCacheError();
    }
  }

  @override
  void saveCompanyListLocal(List<Company> list) {
    try {
      if (companyBox.isNotEmpty) {
        final keys = companyBox.keys;

        for (final key in keys) {
          if (list.map((company) => company.id).toList().contains(key)) {
            // ignore_for_file: avoid_function_literals_in_foreach_calls
            list.forEach((company) => companyBox.put(company.id, company));
          } else {
            companyBox.delete(key);
          }
        }
      } else {
        list.forEach((company) => companyBox.put(company.id, company));
      }
    } catch (e) {
      throw LocalCacheError();
    }
  }

  @override
  Map<String, dynamic> returnUserMapToSave(Map<String, dynamic> json) {
    try {
      final userMap = <String, dynamic>{};
      final keys = json.keys;
      for (final key in keys) {
        if (key == 'ID' || key == 'RegisterMode' || key == 'access_token') {
          userMap.putIfAbsent(key, () => json[key]);
        }
      }
      userMap.putIfAbsent('expireDate',
          () => DateTime.now().add(const Duration(hours: 1)).toString());
      return userMap;
    } catch (e) {
      throw LocalCacheError();
    }
  }

  @override
  void deleteLocalUser() {
    try {
      userBox.delete(1);
      profileBox.delete(1);
    } catch (e) {
      throw LocalCacheError();
    }
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
  Future<List<Company>> getSavedCompany(String pattern) async {
    try {
      return companyBox.values.toList();
    } catch (e) {
      throw LocalCacheError();
    }
  }

  @override
  Future<Map<String, dynamic>> returnProfileMapDataAsMap(
    Profile profile,
  ) async {
    try {
      final user = userBox.get(1);
      final result = await testComporessList(profile.photo);
      // print(result);
      final map = profile.toCreateUser()
        ..update('ID', (value) => user!.id)
        ..update('RegisterMode', (value) => user!.registerMode)
        ..update('access_token', (value) => user!.accessToken)
        ..update('PhotoUrl', (value) => base64Encode(result.toList()));
      return map;
    } catch (e) {
      throw LocalCacheError();
    }
  }

  Future<Uint8List> testComporessList(Uint8List list) async {
    try {
      final result = await FlutterImageCompress.compressWithList(
        list,
        minHeight: 110,
        minWidth: 110,
        quality: 100,
        rotate: 0,
        format: CompressFormat.jpeg,
      );
      return result;
    } catch (e) {
      return _readProfileImageFromAssets();
    }
  }

  @override
  void deleteNews() {
    try {
      final keys = newsBox.keys;
      for (var key in keys) {
        newsBox.delete(key);
      }
    } catch (e) {
      throw LocalCacheError();
    }
  }

  @override
  List<Company> searchCompany(String pattern) {
    if (pattern.isNotEmpty) {
      return companyBox.values
          .toList()
          .where((company) =>
              company.name.toLowerCase().startsWith(pattern.toLowerCase()))
          .toList();
    }
    return companyBox.values.map((company) => company).toList();
  }

  Future<Uint8List> _readProfileImageFromAssets() async {
    final list = await rootBundle.load('assets/icons/profile.png');
    return list.buffer.asUint8List();
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
