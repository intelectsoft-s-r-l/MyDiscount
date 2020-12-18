import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TopBarImageQRPage extends StatelessWidget {
  const TopBarImageQRPage({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(width: size.width,
        child: SvgPicture.asset(
            'assets/icons/top.svg',width: size.width,height: size.height*.18,
            fit: BoxFit.fill,
          ),
      );
  }
}
