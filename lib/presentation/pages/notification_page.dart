import 'package:flutter/material.dart';

import '../../core/localization/localizations.dart';
import '../../domain/entities/news_model.dart';
import '../../domain/repositories/is_service_repository.dart';
import '../../injectable.dart';
import '../widgets/circular_progress_indicator_widget.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/news_page_widgets/news_item.dart';

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
      title: AppLocalizations.of(context).translate('news'),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: FutureBuilder<List<News>>(
          future: getIt<IsService>().getAppNews(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: size.width,
                      height: size.width,
                      child: Stack(
                        children: [
                          Positioned(
                            top: size.width * .15,
                            left: 0,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width * .75,
                              child: FittedBox(
                                  fit: BoxFit.fill,
                                  child:
                                      Image.asset('assets/icons/no_news.png')),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: size.width * .75,
                            child: Container(
                              alignment: Alignment.center,
                              width: size.width,
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate('nonews'),
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  separatorBuilder: (context, index) => Container(
                    padding: const EdgeInsets.only(left: 7, right: 7),
                    height: 30,
                    child: const Divider(
                      //height: 10.0,
                      thickness: 3.0,
                      // color: Colors.red,
                    ),
                  ),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    final news = snapshot.data[index];
                    return NewsListItem(
                      news: news,
                      size: size,
                    );
                  },
                );
              }
            }
            if (snapshot.hasError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: size.width,
                    height: size.width,
                    child: Stack(
                      children: [
                        Positioned(
                          top: size.width * .15,
                          left: 0,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width * .75,
                            child: FittedBox(
                                fit: BoxFit.fill,
                                child: Image.asset('assets/icons/no_news.png')),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          top: size.width * .75,
                          child: Container(
                            alignment: Alignment.center,
                            width: size.width,
                            child: Text(
                              AppLocalizations.of(context).translate('nonews'),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            return CircularProgresIndicatorWidget();
          },
        ),
      ),
    );
  }
}
