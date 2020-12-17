import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TopBarImage extends StatelessWidget {
  const TopBarImage({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SvgPicture.asset(
            'assets/icons/top.svg',width: size.width,height: size.height*.18,
            fit: BoxFit.fill,
          ),
      );
  }
}
