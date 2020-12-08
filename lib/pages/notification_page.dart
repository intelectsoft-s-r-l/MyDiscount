import 'package:MyDiscount/models/news_model.dart';
import 'package:MyDiscount/services/news_service.dart';
import 'package:MyDiscount/widgets/news_header_widget.dart';
import 'package:MyDiscount/widgets/news_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../localization/localizations.dart';
import '../widgets/top_bar_image.dart';
import '../widgets/top_bar_text.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  NewsService service = NewsService();

  @override
  void initState() {
    super.initState();
    service.getNews();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey.shade200,/* Color(0x00F5F5F5), */
      body: Column(
        children: [
          Stack(
            children: [
              TopBarImage(size: size),
              AppBarText(
                  size: size,
                  text: AppLocalizations.of(context).translate('text23')),
            ],
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: Hive.box<News>('news').listenable(),
              builder: (context, Box<News> box, _) {
                if (box.values.isEmpty) {
                  return Center(
                    child: Text("News list is empty"),
                  );
                } else {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    //padding: EdgeInsets.only(right: 5),
                    separatorBuilder: (context, index) => Container(
                      height: 10,
                      //color: Colors.green,
                    ),
                    //shrinkWrap: true,
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      News news = box.getAt(index);
                      int milisec = int.tryParse(news.dateTime
                          .replaceAll('/Date(', '')
                          .replaceAll('+0300)/', '')
                          .replaceAll('+0200)/', ''));
                      final date = DateFormat('d MMM yyyy H:mm:ss').format(
                        DateTime.fromMillisecondsSinceEpoch(milisec),
                      );
                      
                      return InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/detailpage',
                              arguments: news);
                        },
                        child: Container(
                          child: Column(
                            //crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              NewsHeaderWidget(
                                date: date,
                                size: size,
                                news: news,
                              ),
                              NewsImageWidget(news: news, size: size),
                            
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
