import 'package:flutter/material.dart';

import '../models/news_model.dart';

class NewsImageWidget extends StatelessWidget {
  final Size size;
  final News news;

  const NewsImageWidget({Key key, this.size, this.news}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
     height: size.width,
      child: ClipRRect(
        child: Image.memory(
          news?.photo,
          filterQuality: FilterQuality.high,
          fit: BoxFit.fill,
          errorBuilder: (context, error, stackTrace) {
            return Container();
          },
        ),
      ),
    );
  }
}
