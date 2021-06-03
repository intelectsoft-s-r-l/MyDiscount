import 'package:flutter/material.dart';

import '../../../../domain/entities/news_model.dart';

class NewsImageWidget extends StatelessWidget {
  final Size size;
  final News news;

  const NewsImageWidget({Key? key, required this.size, required this.news})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.width,
      child: Image.memory(
        news.photo,
        filterQuality: FilterQuality.high,
        fit: BoxFit.fill,
        errorBuilder: (context, error, stackTrace) {
          return Container();
        },
      ),
    );
  }
}
