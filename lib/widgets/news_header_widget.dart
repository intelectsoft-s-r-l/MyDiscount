import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';

import '../models/news_model.dart';

class NewsHeaderWidget extends StatelessWidget {
  const NewsHeaderWidget({
    Key key,
    @required this.size,
    @required this.news,
  }) : super(key: key);

  final Size size;
  final News news;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 120,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          width: MediaQuery.of(context).size.width,
        ),
        Positioned(
          top: 25,
          left: 60,
          child: Container(
            padding: EdgeInsets.only(
              right: 10,
            ),
            child: Text(
              news.dateTime,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.black38),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        Positioned(
          top: 45,
          left: 0,
          child: Container(
            width: size.width * .97,
            padding: EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            child: Html(data: news.header),
          ),
        ),
        Positioned(
          top: 10,
          left: 60,
          child: Container(
            child: Text(
              news.companyName.toString(),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: Container(
              width: 60,
              height: 60,
              child: Image.memory(
                news.logo,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container();
                },
              )),
        ),
      ],
    );
  }
}
