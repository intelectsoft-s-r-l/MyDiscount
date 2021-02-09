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
    if (await _prefs.readNewsState()) {
      if (await status.isConnected) {
        final serviceName = await getServiceNameFromRemoteConfig();
        final id = await readEldestNewsId();
        final url = '$serviceName/json/GetAppNews?ID=$id';
        final response = await http.get(url, headers: credentials.header);
        final Map<String, dynamic> decodedResponse =
            json.decode(response.body) as Map<String, dynamic>;

        final list = decodedResponse['NewsList'] as List;
        final parseDate =
            formater.parseDateTimeAndSetExpireDate(list, 'CreateDate');
        final dat = formater.checkImageFormatAndSkip(parseDate, 'CompanyLogo');

        final dataList = formater.checkImageFormatAndSkip(dat, 'Photo');
        dataList
            .map((e) => News.fromJson(e as Map<String, dynamic>))
            .toList()
            .forEach((element) => _saveNewsOnDB(element));
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
    return [];
  }

/* https://api.edi.md/ISMobileDiscountService/json/GetAppNews?ID={ID}*/
  Future<String> readEldestNewsId() async {
    final listOfKeys = newsBox.keys;
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

  Future<void> _saveNewsOnDB(News news) async {
    newsBox.put(news.id, news);
  }

  Future<List<News>> _getReversedNewsList() async {
    final List<News> newsList = [];
    final keys = newsBox.keys;
    for (final int key in keys) {
      final news = newsBox.get(key);
      newsList.add(news);
    }
    return newsList.reversed?.toList();
  }
}
