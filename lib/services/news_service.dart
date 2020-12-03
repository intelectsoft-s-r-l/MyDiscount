import 'dart:convert';

import 'package:MyDiscount/constants/credentials.dart';
import 'package:MyDiscount/models/company_model.dart';
import 'package:MyDiscount/models/news_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class NewsService {
  Map<String, String> _headers = {
    'Content-type': 'application/json; charset=utf-8',
    'Authorization': 'Basic ' + Credentials.encoded,
  };
  Future<List<News>> getNews() async {
    const url = 'http://dev.edi.md/ISMobileDiscountService/json/GetNews?ID=0';
    final response = await http.get(url, headers: _headers);
    final decodedResponse = json.decode(response.body);
    print(decodedResponse);
    final list = decodedResponse['NewsList'] as List;
    final List<News>  news = list
        .map((e) => News.fromJson(e))
        .toList()
       /*  .forEach((element) => intializeNewsDB(element)) */;
    return news;
  }

  Future<void> intializeNewsDB(News news) async {
    await Hive.initFlutter();
    Hive.isAdapterRegistered(1)
        // ignore: unnecessary_statements
        ? null
        : Hive.registerAdapter<News>(NewsAdapter());
    await Hive.openBox<News>('news');
    Box<News> companyBox = Hive.box<News>('news');
    companyBox.add(News(
      companyName: news.companyName,
      appType: news.appType,
      companyId: news.companyId,
      content: news.content,
      dateTime: news.dateTime,
      header: news.header,
      id: news.id,
      photo: news.photo,
    ));
    print(companyBox.values);
    //companyBox.deleteFromDisk();
  }
}
