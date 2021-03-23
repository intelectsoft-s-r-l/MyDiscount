import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final Widget child;
  final String title;

  const CustomAppBar({Key key, this.title, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          title,
          style:const TextStyle(fontSize: 18),
        ),
        elevation: 0,
      ),
      body: Container(
        color: Colors.green,
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: ClipRRect(
            borderRadius:const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
