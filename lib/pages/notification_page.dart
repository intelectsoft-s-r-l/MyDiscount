import 'package:MyDiscount/models/received_notification.dart';

import 'package:MyDiscount/widgets/localizations.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../widgets/top_bar_image.dart';
import '../widgets/top_bar_text.dart';

class NotificationPage extends StatelessWidget {
  //final ReceivedNotification notification;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
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
          ValueListenableBuilder(
            valueListenable:
                Hive.box<ReceivedNotification>('testBox').listenable(),
            builder: (context, Box<ReceivedNotification> box, _) {
              if (box.values.isEmpty)
                return Center(
                  child: Text("Todo list is empty"),
                );
              return ListView.builder(
                itemCount: box.values.length,
                itemBuilder: (context, index) {
                  ReceivedNotification res = box.getAt(index);
                  return ListTile(
                    title: Text(res.body),
                    subtitle: Text(res.title),
                  );
                },
              );
            },
          ),
          /*  Container(
            height: size.height * .6,
            child: FutureBuilder<List<Map<String, dynamic>>>(
              initialData: [],
             // future: reedFromDB(),
              builder: (context, snapshot) => ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) => snapshot.data.length == null
                    ? Container(
                        height: 20,
                        width: 20,
                        child: Text(snapshot.data[index]['body']))
                    : Container(),
              ),
            ),
          ) */
        ],
      ),
    );
  }
}
