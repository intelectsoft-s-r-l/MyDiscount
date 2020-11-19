import 'package:flutter/material.dart';

class AppBarText extends StatelessWidget {
  const AppBarText({
    Key key,
    @required this.size,
    @required this.text,
  }) : super(key: key);

  final Size size;
  final String text;

  @override
  Widget build(BuildContext context) {
    //final siz = MediaQuery.of(context).devicePixelRatio;
    return Positioned(
      top: size.height * .08,
      left: size.width * .1,
      child: Container(
        width: size.width * .8,
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            //fontSize: 22,
            fontWeight: FontWeight.bold,
          ),textScaleFactor: 1,
        ),
      ),
    );
  }
}
