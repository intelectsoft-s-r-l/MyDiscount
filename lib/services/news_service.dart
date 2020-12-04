import 'dart:convert';

import 'package:MyDiscount/constants/credentials.dart';
import 'package:MyDiscount/core/image_format.dart';
//import 'package:MyDiscount/models/company_model.dart';
import 'package:MyDiscount/models/news_model.dart';
import 'package:MyDiscount/services/shared_preferences_service.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class NewsService {
  ImageFormater formater = ImageFormater();
  SharedPref sPref = SharedPref();
  Map<String, String> _headers = {
    'Content-type': 'application/json; charset=utf-8',
    'Authorization': 'Basic ' + Credentials.encoded,
  };
  Future<List<News>> getNews() async {
    final id = await readIndexId();
    final url = 'http://dev.edi.md/ISMobileDiscountService/json/GetNews?ID=$id';
    final response = await http.get(url, headers: _headers);
    final decodedResponse = json.decode(response.body);
    print(decodedResponse);
    //data.remove('id');
    final list = decodedResponse['NewsList'] as List;
    int d = int.parse(id);
    for (Map map in list) {
      if (map['ID'] > d) {
        d = map['ID'];
      }
    }
    final dataList = formater.checkImageFormatAndSkip(list,'Photo');
    final List<News> newsList = dataList.map((e) => News.fromJson(e)).toList();
    saveLastIndexId(d);
    /*  .forEach((element) => intializeNewsDB(element)) */
    return newsList;
  }

  void saveLastIndexId(int id) async {
    final data = await sPref.instance;
    data.setString('id', id.toString());
    //data.clear();
    print(id);
  }

  Future<String> readIndexId() async {
    String ids = '0';
    // final data = await sPref.instance;
    // ids = data.getString('id');
    return ids;
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
  }

 /*  Future<News> readDb() {
    Hive.box('news').get(1);
  } */
}
/* ValueListenableBuilder(
            valueListenable:
                Hive.box<News>('news').listenable(),
            builder: (context, Box<News> box, _) {
              if (box.values.isEmpty)
                return Center(
                  child: Text("Todo list is empty"),
                );
              return Expanded(
                // width: size.width,
                // height: size.height * .729,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: box.values.length,
                  itemBuilder: (context, index) {
                    News res = box.getAt(index);
                    return ListTile(leading:Image.memory(
                                    Base64Decoder().convert(
                                      '${res.photo.toString().characters.skip(23)}',
                                    ),
                                    fit: BoxFit.contain,
                                  ), 
                     /*  */   title: Text(res.companyName.toString()),
                      subtitle: Html(data:res.header),
                      trailing: Text(res.id.toString()),
                    );
                  },
                ),
              );
            },
          ),  */
