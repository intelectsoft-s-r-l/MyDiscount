import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' as htmlparser;


import '../core/localization/localizations.dart';
import '../models/news_model.dart';
import '../services/news_service.dart';
import '../widgets/circular_progress_indicator_widget.dart';
import '../widgets/html_text_view_widget.dart';
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
              child: FutureBuilder<List<News>>(
                future: service.getNews(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.length == 0) {
                      return Center(
                        child: Container(
                          width: size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  height: 200,
                                  width: 200,
                                  child:
                                      Image.asset('assets/icons/noNews.jpeg')),
                              Text(AppLocalizations.of(context)
                                  .translate('text65')),
                            ],
                          ),
                        ),
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

class NewsItem extends StatefulWidget {
  final News news;
  final Size size;

  const NewsItem({Key key, this.news, this.size}) : super(key: key);
  @override
  _NewsItemState createState() => _NewsItemState();
}

class _NewsItemState extends State<NewsItem> {
  @override
  Widget build(BuildContext context) {
    final news = widget.news;
    final size = widget.size;

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/detailpage', arguments: news);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[350]),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(19),
          child: Container(
            child: Column(
              children: [
                NewsHeaderWidget(
                  size: size,
                  news: news,
                ),
                Html(
                  data: news.header,
                ),
                DetailedNews(
                  news: news,
                  size: size,
                ),
                SizedBox(
                  height: 10,
                ),
                NewsImageWidget(news: news, size: size),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DetailedNews extends StatefulWidget {
  final News news;
  final Size size;

  const DetailedNews({Key key, this.news, this.size}) : super(key: key);
  @override
  _DetailedNewsState createState() => _DetailedNewsState();
}

class _DetailedNewsState extends State<DetailedNews> {
  bool showText = false;
  @override
  Widget build(BuildContext context) {
    final news = widget.news;
    final size = widget.size;
    final string = htmlparser.parse(news.content);
    final str = string.body.text;
    final list = str.padLeft(1, ' ');
    /* List<String> st = list.split('\n');
    print('text:${st[0]}'); */
    return Container(
      child: Column(
        children: [
          InkResponse(
            autofocus: true,
            onTap: () {
              setState(() {
                showText = !showText;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                !showText
                    ? Container(
                        //height: 55,
                        padding: EdgeInsets.only(left: 5),
                        width: size.width * .95,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              list
                              /*  .replaceFirst('\n\n', '') */
                              /*  .replaceFirst('\n', '') */,
                              maxLines: 3,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Afișați mai multe',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          Container(
            child: showText
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      HtmlText(
                        list: news,
                      ),
                      InkResponse(
                        onTap: () {
                          setState(() {
                            showText = !showText;
                          });
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              'Mai Putin',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}
