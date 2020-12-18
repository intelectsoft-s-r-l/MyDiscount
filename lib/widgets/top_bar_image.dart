import 'package:flutter/material.dart';

class TopBarImage extends StatelessWidget {
  const TopBarImage({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(width: size.width,
        child: Image.asset(
            'assets/icons/Background.png',width: size.width,height: size.height*.18,
            fit: BoxFit.fill,
          ),
      );
  }
}