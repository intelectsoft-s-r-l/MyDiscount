import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../models/news_model.dart';
import '../widgets/html_text_view_widget.dart';

class DetailNewsPage extends StatelessWidget {
  const DetailNewsPage({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final News news = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(news.companyName),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Container(height: MediaQuery.of(context).size.longestSide,
        color: Colors.green,
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Container(
              color: Colors.white,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Html(data: news.header),
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: news.photo != null && news.photo != []
                          ? Image.memory(
                              news.photo,
                              fit: BoxFit.cover,
                            )
                          : Container(),
                    ),
                  ),
                  Container(
                    child: HtmlText(
                      list: news,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
