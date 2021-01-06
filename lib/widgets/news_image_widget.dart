import 'package:flutter/material.dart';

import '../models/news_model.dart';

class NewsImageWidget extends StatelessWidget {
  final Size size;
  final News news;

  const NewsImageWidget({Key key, this.size, this.news}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      //alignment: Alignment.center,
      width: size.width,
      //margin: EdgeInsets.only(left: 5, right: 5),
      //padding: EdgeInsets.only(left: 5, right: 5),
      child: ClipRRect(
          // borderRadius: BorderRadius.only(
          //     bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
          child: Image.memory(
        news?.photo,
        filterQuality: FilterQuality.high,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container();
        },
      )),
    );
  }
}
