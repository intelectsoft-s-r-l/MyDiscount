import 'package:flutter/material.dart';

import '../widgets/top_bar_image.dart';
import '../widgets/top_bar_text.dart';

class NotificationSettingsPage extends StatefulWidget {
  @override
  _NotificationSettingsPageState createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  var val = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              TopBarImage(size: size),
              AppBarText(size: size, text: 'Notifications Settings'),
              Positioned(
                top: size.height * .06,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(10 ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('data'),
                    Switch(
                        value: val,
                        onChanged: (value) {
                          val = value;
                        }),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
