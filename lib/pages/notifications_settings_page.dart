
import '../widgets/widgets/top_bar_image.dart';
import 'package:MyDiscount/widgets/widgets/top_bar_text.dart';
import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatelessWidget {
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
          )
        ],
      ),
    );
  }
}
