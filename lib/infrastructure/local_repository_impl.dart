import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:my_discount/core/failure.dart';

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
    try {
      if (profileBox.isNotEmpty) {
        return profileBox?.get(1);
      } else {
        return Profile.empty();
      }
    } catch (e) {
      throw LocalCacheError();
    }
  }

  @override
  List<News> getLocalNews() {
    try {
      final newsList = <News>[];
      final keys = newsBox?.keys;
      for (int key in keys) {
        final news = newsBox?.get(key);
        newsList.add(news);
      }
      return newsList.reversed?.toList();
    } catch (e) {
      throw LocalCacheError();
    }
  }

  @override
  User getLocalUser() {
    try {
      final _user = userBox?.get(1);
      return _user;
    } catch (e) {
      throw LocalCacheError();
    }
  }

  @override
  Profile saveLocalClientInfo(Profile profile) {
    try {
      profileBox?.put(1, profile);
      return profile;
    } catch (e) {
      throw LocalCacheError();
    }
  }

  @override
  void saveLocalNews(List newsList) {
    try {
      newsList
          .map((e) => News.fromJson(e))
          .toList()
          .forEach((news) => newsBox?.put(news.id, news));
    } catch (e) {
      throw LocalCacheError();
    }
  }

  @override
  User saveLocalUser(User user) {
    try {
      userBox?.put(1, user);
      return user;
    } catch (e) {
      throw LocalCacheError();
    }
  }

  @override
  String readEldestNewsId() {
    try {
      final listOfKeys = newsBox?.keys;

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
  void saveLocalCompanyList(List<Company> list) {
    try {
      // ignore: avoid_function_literals_in_foreach_calls
      list.forEach((company) {
        companyBox.put(company.id, company);
      });
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
          () => DateTime.now().add(const Duration(minutes: 1)).toString());
      return userMap;
    } catch (e) {
      throw LocalCacheError();
    }
  }

  @override
  Future<Map<String, dynamic>> getFacebookProfile(String token) async {
    try {
      final _graphResponse = await http.get(Uri.parse(
          'https://graph.facebook.com/v2.6/me?fields=id,name,picture,email&access_token=$token'));
      return json.decode(_graphResponse.body) as Map<String, dynamic>;
    } catch (e) {
      rethrow;
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
  Future<List<Company>> getCachedCompany(String pattern) async {
    try {
      final keys = companyBox.keys;
      final list = <Company>[];
      if (companyBox.isNotEmpty) {
        for (int key in keys) {
          if (pattern.isNotEmpty) {
            final company = companyBox.get(key);
            if (company.name.contains(pattern)) {
              list.add(company);
            }
          } else {
            final company = companyBox.get(key);
            if (company.name.contains(pattern)) {
              list.add(company);
            }
          }
        }
        return list;
      } else {
        throw EmptyList();
      }
    } catch (e) {
      throw LocalCacheError();
    }
  }

  @override
  Future<Map<String, dynamic>> returnProfileMapDataAsMap(
      Profile profile) async {
    try {
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
      throw LocalCacheError();
    }
  }

  @override
  List<News> deleteNews() {
    try {
      final keys = newsBox.keys;
      for (var key in keys) {
        newsBox.delete(key);
      }
      return [];
    } catch (e) {
      throw LocalCacheError();
    }
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
