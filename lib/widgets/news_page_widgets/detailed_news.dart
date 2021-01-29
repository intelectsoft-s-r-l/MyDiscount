import 'package:MyDiscount/core/localization/localizations.dart';
import 'package:MyDiscount/models/news_model.dart';

import 'package:flutter/material.dart';
import 'package:simple_html_css/simple_html_css.dart';
import 'package:url_launcher/url_launcher.dart';

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
    //print(news.content);
    final textContent = HTML.toTextSpan(context, news.content,
        defaultTextStyle: TextStyle(
          fontSize: 14,
        ), linksCallback: (url) async {
      if (await canLaunch(url)) {
        launch(url);
      } else {
        throw "Can't Launch Url ";
      }
    });

    return Container(
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            !showText
                ? Container(
                    padding: EdgeInsets.only(left: 12),
                    width: size.width * .95,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: textContent,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textHeightBehavior: TextHeightBehavior.fromEncoded(2),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InkResponse(
                          autofocus: true,
                          onTap: () {
                            setState(() {
                              showText = !showText;
                            });
                          },
                          child: Text(
                            AppLocalizations.of(context).translate('more'),
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ))
                : Container(),
          ]),
          Container(
            child: showText
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          padding: EdgeInsets.only(left: 12,bottom: 12),
                          child: RichText(
                            text: textContent,
                            // maxLines: 3,
                            // overflow: TextOverflow.ellipsis,
                            textHeightBehavior:
                                TextHeightBehavior.fromEncoded(2),
                          )),
                      /*  HtmlText(
                        list: news,
                      ), */
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
                              AppLocalizations.of(context).translate('less'),
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
