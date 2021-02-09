import 'dart:async';
import 'dart:convert';

import 'package:MyDiscount/domain/entities/news_model.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import '../core/constants/credentials.dart';
import '../core/formater.dart';

import '../services/internet_connection_service.dart';
import '../services/shared_preferences_service.dart';
import '../services/remote_config_service.dart';

@injectable
class NewsService {
  final SharedPref _prefs;
  final Formater formater;
  final Credentials credentials;
  final NetworkConnectionImpl status;
  final Box<News> newsBox = Hive.box<News>('news');

  NewsService(this._prefs, this.formater, this.credentials, this.status);

  Future<List<News>> getNews() async {
    try {
      if (await _prefs.readNewsState()) {
        if (await status.isConnected) {
          final serviceName = await getServiceNameFromRemoteConfig();

          final id = await _readEldestNewsId();

          final url = '$serviceName/json/GetAppNews?ID=$id';

          final response = await http.get(url, headers: credentials.header);

          final Map<String, dynamic> _decodedResponse =
              json.decode(response.body);

          final List<dynamic> _listOfNewsMaps = _decodedResponse['NewsList'];

          formater.parseDateTime(_listOfNewsMaps, 'CreateDate');

          formater.checkImageFormatAndDecode(_listOfNewsMaps, 'CompanyLogo');

          formater.checkImageFormatAndDecode(_listOfNewsMaps, 'Photo');

          _saveNewsinDBAsObjects(_listOfNewsMaps);

          return _getReversedNewsList();
        } else {
          if (newsBox.isNotEmpty) {
            return _getReversedNewsList();
          }
        }
      } else {
        final keys = newsBox.keys;
        if (newsBox.isNotEmpty) newsBox.deleteAll(keys);
      }
    } catch (e) {
      return [];
    }
    return [];
  }

  Future<String> _readEldestNewsId() async {
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

  _saveNewsinDBAsObjects(List _listOfNewsMaps) {
    _listOfNewsMaps
        .map((e) => News.fromJson(e))
        .toList()
        .forEach((element) => _saveNewsOnDB(element));
  }

  Future<void> _saveNewsOnDB(News news) async {
    newsBox.put(news.id, news);
  }

  Future<List<News>> _getReversedNewsList() async {
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
}
