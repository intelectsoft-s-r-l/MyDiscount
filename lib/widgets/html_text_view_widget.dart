import 'package:MyDiscount/models/news_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

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
      padding: EdgeInsets.only(left: 5, right: 5,top: 5,bottom: 5),
      child: Html(
        data: list.content,
      ),
    );
  }
}
