import 'package:flutter/material.dart';

import '../../../domain/entities/news_model.dart';
import 'news_item/news_item.dart';

class NewsListWidget extends StatelessWidget {
  const NewsListWidget({Key? key, required this.size, required this.newsList})
      : super(key: key);
  final List<News> newsList;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      separatorBuilder: (context, index) => Container(
        padding: const EdgeInsets.only(left: 7, right: 7),
        height: 30,
        child: const Divider(
          thickness: 3.0,
        ),
      ),
      itemCount: newsList.length,
      itemBuilder: (context, index) {
        final news = newsList[index];
        return NewsItem(
          news: news,
          size: size,
        );
      },
    );
  }
}
