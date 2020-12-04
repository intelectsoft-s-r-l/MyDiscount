import 'dart:convert';

import 'package:MyDiscount/models/news_model.dart';
import 'package:MyDiscount/services/news_service.dart';
import 'package:MyDiscount/widgets/html_text_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';

// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import '../models/received_notification.dart';

import '../localization/localizations.dart';
import '../widgets/top_bar_image.dart';
import '../widgets/top_bar_text.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  NewsService service = NewsService();

  @override
  void initState() {
    super.initState();
    service.getNews();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      //backgroundColor: Colors.grey,
      body: Column(
        children: [
          Stack(
            children: [
              TopBarImage(size: size),
              AppBarText(
                  size: size,
                  text: AppLocalizations.of(context).translate('text23')),
            ],
          ),
          Expanded(
            // height: MediaQuery.of(context).size.height*.75,
            // width: MediaQuery.of(context).size.width,
            child: FutureBuilder<List<News>>(
              future: service.getNews(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  print('snapshot:$snapshot');
                  List<News> list = snapshot.data;
                  return Container(
                    // padding: EdgeInsets.only(/* left: 5, */ right: 5),
                    child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      //padding: EdgeInsets.only(right: 5),
                      separatorBuilder: (context, index) => Container(
                        height: 10,
                        //color: Colors.green,
                      ),
                      //shrinkWrap: true,
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        String data = list[index].dateTime;
                        int milisec = int.tryParse(data
                            .replaceAll('/Date(', '')
                            .replaceAll('+0300)/', '')
                            .replaceAll('+0200)/', ''));
                        final date = DateFormat('d MMM yyyy H:mm:ss').format(
                          DateTime.fromMillisecondsSinceEpoch(milisec),
                        );
                        return InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/detailpage',
                                arguments: list[index]);
                          },
                          child: Column(
                            //crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    // padding: EdgeInsets.only(left: 5),
                                    margin: EdgeInsets.only(left: 5, right: 5),
                                    height: 75,

                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                      color: Colors.red,
                                    ),
                                    width:
                                        MediaQuery.of(context).size.width ,
                                  ),
                                  Positioned(
                                    top: 5,
                                    right: 10,
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                      ),
                                      child: Text(
                                        date,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 12,
                                    left: 0,
                                    child: Container(
                                      width: size.width * .97,
                                      padding: EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                      ),
                                      child: Html(data: list[index].header),
                                    ),
                                  ),
                                  Positioned(
                                    top: 5,
                                    left: 10,
                                    child: Container(
                                      child: Text(
                                        list[index].companyName.toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                //alignment: Alignment.center,
                                width: size.width,
                                margin: EdgeInsets.only(left: 5, right: 5),
                                //padding: EdgeInsets.only(left: 5, right: 5),
                                child: ClipRRect(
                                 // borderRadius: BorderRadius.circular(10),
                                  child: list[index].photo != null ||
                                          list[index].photo != ''
                                      ? Image.memory(
                                          Base64Decoder().convert(
                                            '${list[index].photo.toString()}',
                                          ),
                                          fit: BoxFit.cover,
                                        )
                                      : Container(),
                                ),
                              ),
                              

                              /* Positioned(
                                bottom: 0,
                                left: 0,
                                child: Container(
                                  // padding: EdgeInsets.only(left: 5),
                                  margin: EdgeInsets.only(left: 5, right: 5),
                                  height: 73,

                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                    color: Colors.white30,
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width * .974,
                                  child: Stack(
                                    children: [
                                      /*  Positioned(
                                      top: -30.0,
                                      left: 0.0,
                                      child: Container(
                                        child: HtmlText(
                                          list: list[index],
                                        ),
                                      ),
                                    ), */
                                    ],
                                  ),
                                ),
                              ), */
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
