import 'package:flutter/material.dart';

import '../../domain/entities/news_model.dart';
import '../../presentation/widgets/news_page_widgets/news_item/news_image_widget.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/news_page_widgets/news_item/html_text_view_widget.dart';

class DetailNewsPage extends StatelessWidget {
  const DetailNewsPage({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final news = ModalRoute.of(context)!.settings.arguments as News;
    final size = MediaQuery.of(context).size;
    return CustomAppBar(
      title: news.companyName,
      child: Container(
        color: Colors.white,
        child: ListView(
          shrinkWrap: true,
          children: [
            HtmlText(data: news.header),
            NewsImageWidget(size: size, news: news),
            HtmlText(data: news.content),
          ],
        ),
      ),
    );
  }
}
