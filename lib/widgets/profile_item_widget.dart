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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              labelText,
              style: TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
              child: Text(
            text,
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          )),
        ],
      ),
    );
  }
}
