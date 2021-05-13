import 'package:flutter/material.dart';
import 'package:simple_html_css/simple_html_css.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/localization/localizations.dart';
import '../../../../domain/entities/news_model.dart';
import 'html_text_view_widget.dart';

class DetailedNews extends StatefulWidget {
  final News? news;
  final Size? size;

  const DetailedNews({Key? key, this.news, this.size}) : super(key: key);
  @override
  _DetailedNewsState createState() => _DetailedNewsState();
}

class _DetailedNewsState extends State<DetailedNews> {
  bool showText = false;
  @override
  Widget build(BuildContext context) {
    final news = widget.news!;
    final size = widget.size;

    final textContent =
        HTML.toTextSpan(context, news.content, linksCallback: (url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw Exception();
      }
    });

    return Container(
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            !showText
                ? Container(
                    padding: const EdgeInsets.only(left: 7),
                    width: size!.width * .95,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: textContent,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textHeightBehavior:
                              const TextHeightBehavior.fromEncoded(2),
                        ),
                        const SizedBox(
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
                            AppLocalizations.of(context)!.translate('more')!,
                            style: const TextStyle(
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
                            const SizedBox(
                              width: 7,
                            ),
                            Text(
                              AppLocalizations.of(context)!.translate('less')!,
                              style: const TextStyle(
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
