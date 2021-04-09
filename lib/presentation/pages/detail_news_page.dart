import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/news_model.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/news_page_widgets/html_text_view_widget.dart';

class DetailNewsPage extends StatelessWidget {
  const DetailNewsPage({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final  news = ModalRoute.of(context).settings.arguments as News;
    final size = MediaQuery.of(context).size;
    return CustomAppBar(
      title: news.companyName,
      child: Container(
        color: Colors.white,
        child: ListView(
          shrinkWrap: true,
          children: [
            Html(
              data: news.header,
              onLinkTap: (url,_,__,___) async {
                if (await canLaunch(url)) {
                await  launch(url);
                } else {
                  throw Exception();
                }
              },
            ),
            Container(
              height: size.width,
              width: size.width,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: news.photo != null && news.photo != []
                    ? Image.memory(
                        news.photo,
                        fit: BoxFit.fill,
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
    );
  }
}
