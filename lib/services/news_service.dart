import 'dart:async';
import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../constants/credentials.dart';
import '../core/formater.dart';
import '../models/news_model.dart';
import '../services/remote_config_service.dart';
//import '../services/shared_preferences_service.dart';

class NewsService {
  Formater formater = Formater();
  Credentials credentials = Credentials();
  Box<News> newsBox = Hive.box<News>('news');
  
 
  Future<void> getNews() async {
    final serviceName = await getServiceNameFromRemoteConfig();
    final id = await readEldestNewsId();
    final url = '$serviceName/json/GetAppNews?ID=$id';
    final response = await http.get(url, headers: credentials.header);
    final decodedResponse = json.decode(response.body);
    print(decodedResponse);

    final list = decodedResponse['NewsList'] as List;
    final parseDate = formater.parseDateTimeAndSetExpireDate(list);
    final dat = formater.checkImageFormatAndSkip(parseDate, 'CompanyLogo');

    final dataList = formater.checkImageFormatAndSkip(dat, 'Photo');
    dataList
        .map((e) => News.fromJson(e))
        .toList()
        .forEach((element) => saveNewsOnDB(element));
  }

  Future<String> readEldestNewsId() async {
    final listOfKeys = newsBox.keys;
    // newsBox.deleteAll(listOfKeys);
    int id = 0;
    if (listOfKeys.isNotEmpty) 
    //checkIfNewsIsNotOld(listOfKeys.toList());
    for (int key in listOfKeys)
      if (key > id) {
        id = key;
      }
    return id.toString();
  }

  Future<void> saveNewsOnDB(News news) async {
    newsBox.put(news.id, news);

    print('companyBoxValue:$newsBox.values');
  }

  void checkIfNewsIsNotOld(List keys) {
    for (int key in keys) {
      final news = newsBox.get(key);
      if (news.expireDate.isBefore(DateTime.now())) {
        newsBox.delete(news.id);
      }
      newsBox.compact();
    }
  }
}
