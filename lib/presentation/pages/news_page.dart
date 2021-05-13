import 'package:flutter/material.dart';
import 'package:my_discount/presentation/widgets/news_page_widgets/news_list/empty_list.dart';
import 'package:my_discount/presentation/widgets/news_page_widgets/news_list/news_list.dart';

import '../../core/localization/localizations.dart';
import '../../domain/entities/news_model.dart';
import '../../domain/repositories/is_service_repository.dart';
import '../../injectable.dart';
import '../widgets/circular_progress_indicator_widget.dart';
import '../widgets/custom_app_bar.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage();
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return CustomAppBar(
      title: AppLocalizations.of(context)!.translate('news'),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: FutureBuilder<List<News>>(
          future: getIt<IsService>().getAppNews(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return EmptyNewsWidget(size: size);
              } else {
                return NewsListWidget(size: size, newsList: snapshot.data!);
              }
            }
            if (snapshot.hasError) {
              return EmptyNewsWidget(size: size);
            }
            return CircularProgresIndicatorWidget();
          },
        ),
      ),
    );
  }
}
