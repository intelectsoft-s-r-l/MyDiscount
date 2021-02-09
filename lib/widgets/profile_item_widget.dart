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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style:const TextStyle(color: Colors.black),
        ),
       const SizedBox(
          height: 15,
        ),
        Text(
          text,
          style:const TextStyle(
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
