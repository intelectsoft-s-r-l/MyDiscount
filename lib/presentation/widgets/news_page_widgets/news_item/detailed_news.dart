import 'package:flutter/material.dart';

import '../../../../domain/entities/news_model.dart';
import '../../../../infrastructure/core/localization/localizations.dart';
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

  void updateText() {
    setState(() {
      showText = !showText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final news = widget.news!;
    final size = widget.size;

    return Container(
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            !showText
                ? Container(
                    width: size!.width * .99,
                    child:
                        /* Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Html(
                          data: news.content,
                          style: {
                            'span': Style(
                                maxLines: 2,
                                textOverflow: TextOverflow.ellipsis),
                            'div': Style(
                                maxLines: 2,
                                textOverflow: TextOverflow.ellipsis), 
                            'p': Style(
                                maxLines: 3,
                                textOverflow: TextOverflow.ellipsis),
                          }, 
                        ),*/
                        /* const SizedBox(
                          height: 10,
                        ), */
                        Padding(
                      padding: const EdgeInsets.only(left: 7),
                      child: InkResponse(
                        autofocus: true,
                        onTap: updateText,
                        child: Text(
                          AppLocalizations.of(context)!.translate('more')!,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    /*  ],
                    ) */
                  )
                : Container(),
          ]),
          Container(
            child: showText
                ? DetailedNewsText(news: news, function: updateText)
                : Container(),
          ),
        ],
      ),
    );
  }
}

class DetailedNewsText extends StatelessWidget {
  const DetailedNewsText({
    Key? key,
    required this.news,
    required this.function,
  }) : super(key: key);

  final VoidCallback function;

  final News news;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        HtmlText(
          data: news.content,
        ),
        InkResponse(
          onTap: function,
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
    );
  }
}