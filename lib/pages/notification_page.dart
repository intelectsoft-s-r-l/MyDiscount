import 'package:MyDiscount/services/fcm_service.dart';
import 'package:MyDiscount/services/fcm_service.dart';
import 'package:MyDiscount/widgets/localizations.dart';
import 'package:flutter/material.dart';

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
          FutureBuilder<List<ReceivedNotification>>(
            initialData: [],
            future: getListOfNotifications(),
            builder: (context, snapshot) => ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) =>snapshot.data.length==null? Text(snapshot.data[index].body) : Container(),
            ),
          )
        ],
      ),
    );
  }
}
