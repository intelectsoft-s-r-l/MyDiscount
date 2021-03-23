import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../domain/entities/news_model.dart';
import '../news_page_widgets/detailed_news.dart';
import '../news_page_widgets/news_header_widget.dart';
import '../news_page_widgets/news_image_widget.dart';

class NewsListItem extends StatelessWidget {
  final News news;
  final Size size;

  const NewsListItem({Key key, this.news, this.size}) : super(key: key);

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
               const SizedBox(
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
