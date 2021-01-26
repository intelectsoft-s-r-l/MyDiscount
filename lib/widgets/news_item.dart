import 'package:MyDiscount/models/news_model.dart';
import 'package:MyDiscount/widgets/detailed_news.dart';
import 'package:MyDiscount/widgets/news_header_widget.dart';
import 'package:MyDiscount/widgets/news_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class NewsItem extends StatelessWidget {
  final News news;
  final Size size;

  const NewsItem({Key key, this.news, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final news =widget.news;
    // final size = widget.size;

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
