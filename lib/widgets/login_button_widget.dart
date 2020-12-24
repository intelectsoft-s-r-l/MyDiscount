import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    Key key,
    @required this.size,
    @required this.function,
    @required this.picture,
    @required this.text,
    @required this.color,
  }) : super(key: key);

  final Size size;
  final Function function;
  final String picture;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: function,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
        height: 40,
        width: size.width * .84,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 30,
            ),
            SvgPicture.asset(
              picture,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                //fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textScaleFactor: 1.4,
            ),
          ],
        ),
      ),
    );
  }
}
