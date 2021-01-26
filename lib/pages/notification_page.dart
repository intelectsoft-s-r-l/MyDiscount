import 'package:flutter/material.dart';

import '../core/localization/localizations.dart';
import '../models/news_model.dart';
import '../services/news_service.dart';
import '../widgets/circular_progress_indicator_widget.dart';
import '../widgets/news_item.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  NewsService service = NewsService();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(AppLocalizations.of(context).translate('news')),
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
              child: FutureBuilder<List<News>>(
                future: service.getNews(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.length == 0) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: size.width,
                            height: size.width,
                            child: Stack(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Positioned(
                                  top: size.width * .15,
                                  left: 0,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height:
                                        MediaQuery.of(context).size.width * .75,
                                    child: FittedBox(
                                        fit: BoxFit.fill,
                                        child: Image.asset(
                                            'assets/icons/no_news.png')),
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  top: size.width * .75,
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: size.width,
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .translate('nonews'),
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        separatorBuilder: (context, index) => Container(
                          padding: EdgeInsets.only(left: 7, right: 7),
                          height: 30,
                          child: Divider(
                            //height: 10.0,
                            thickness: 3.0,
                            // color: Colors.red,
                          ),
                        ),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          News news = snapshot.data[index];
                          return NewsItem(
                            news: news,
                            size: size,
                          );
                        },
                      );
                    }
                  }
                  return CircularProgresIndicatorWidget();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
