import 'package:flutter/material.dart';

class ProfileItemWidget extends StatelessWidget {
  const ProfileItemWidget({
    Key key,
    this.labelText,
    this.text,
  }) : super(key: key);
  final String labelText;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Text(
              labelText,
              style: TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(
            height: 9,
          ),
          Container(
              child: Text(
            text,
            style: TextStyle(
                color: Colors.black,
                fontSize: 17.0,
                fontWeight: FontWeight.bold),
          )),
        ],
      ),
    );
  }
}
