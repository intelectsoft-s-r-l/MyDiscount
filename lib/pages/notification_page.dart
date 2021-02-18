import 'package:MyDiscount/domain/entities/news_model.dart';
import 'package:MyDiscount/infrastructure/is_service_impl.dart';
import 'package:MyDiscount/injectable.dart';
import 'package:MyDiscount/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

import '../core/localization/localizations.dart';

import '../widgets/circular_progress_indicator_widget.dart';
import '../widgets/news_page_widgets/news_item.dart';

class NotificationPage extends StatefulWidget {
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
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: FutureBuilder<List<News>>(
          future: getIt<IsServiceImpl>().getAppNews(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data?.length == 0) {
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
                              child: FittedBox(fit: BoxFit.fill, child: Image.asset('assets/icons/no_news.png')),
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
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  physics: BouncingScrollPhysics(),
                  separatorBuilder: (context, index) => Container(
                    padding: EdgeInsets.only(left: 7, right: 7),
                    height: 30,
                    child: Divider(
                      //height: 10.0,
                      thickness: 3.0,
                      // color: Colors.red,
                    ),
                  ),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    News news = snapshot.data[index];
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
                            child: FittedBox(fit: BoxFit.fill, child: Image.asset('assets/icons/no_news.png')),
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
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
