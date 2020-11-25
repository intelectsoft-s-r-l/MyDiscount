import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../localization/localizations.dart';
import '../models/received_notification.dart';
import '../widgets/top_bar_image.dart';
import '../widgets/top_bar_text.dart';

class NotificationPage extends StatelessWidget {
  
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
                Hive.box<ReceivedNotification>('notification').listenable(),
            builder: (context, Box<ReceivedNotification> box, _) {
             
              if (box.values.isEmpty)
                return Center(
                  child: Text("Todo list is empty"),
                );
              return Expanded(
                // width: size.width,
                // height: size.height * .729,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: box.values.length,
                  itemBuilder: (context, index) {
                    ReceivedNotification res = box.getAt(index);
                    return Dismissible(
                      direction: DismissDirection.startToEnd,
                      key: UniqueKey(),
                      background: Container(color: Colors.red),
                      child: ListTile(
                        title: Text(res.title),
                        subtitle: Text(res.body),
                      ),
                      onDismissed: (direction) => box.deleteAt(index),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
