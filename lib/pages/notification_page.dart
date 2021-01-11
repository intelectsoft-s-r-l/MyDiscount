import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

import '../core/localization/localizations.dart';
import '../models/news_model.dart';
import '../services/news_service.dart';
import '../widgets/news_header_widget.dart';
import '../widgets/news_image_widget.dart';

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(AppLocalizations.of(context).translate('text23')),
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade200,
      body: Container(
        color: Colors.green,
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
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
                      separatorBuilder: (context, index) => Container(
                        height: 10,
                      ),
                      itemCount: box.length,
                      itemBuilder: (context, index) {
                        News news = box?.getAt(index);

                        return InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/detailpage',
                                arguments: news);
                          },
                          child: Container(
                            child: Column(
                              children: [
                                NewsHeaderWidget(
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
          ),
        ),
      ),
    );
  }
}
