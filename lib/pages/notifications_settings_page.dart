import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                child: SvgPicture.asset(
                  'assets/icons/top.svg',
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                top: size.height * .08,
                left: size.width * .1,
                child: Container(
                  width: size.width * .8,
                  child: Text(
                    'Notifications Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
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
