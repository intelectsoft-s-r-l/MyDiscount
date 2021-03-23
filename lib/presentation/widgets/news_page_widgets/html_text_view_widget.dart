import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../domain/entities/news_model.dart';

class HtmlText extends StatelessWidget {
  const HtmlText({
    Key key,
    @required this.list,
  }) : super(key: key);

  final News list;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(
          /* left: 5, */ right: 5, /* top: 5, */ bottom: 5),
      child: Html(
        data: list.content,
        onLinkTap: (url) async {
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw Exception(); //"Can't Launch Url ";
          }
        },
      ),
    );
  }
}
