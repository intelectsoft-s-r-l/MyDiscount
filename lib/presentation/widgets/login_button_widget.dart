import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../aplication/auth/sign_in/sign_form_bloc.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    Key key,
    @required this.size,
    @required this.event,
    @required this.picture,
    @required this.text,
    @required this.color,
  }) : super(key: key);

  final Size size;
  final SignFormEvent event;
  final String picture;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final ctx = Provider.of<SignFormBloc>(context);
   
    // ignore: deprecated_member_use
    return FlatButton(
      onPressed: () => ctx.add(event),
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
        height: 40,
        width: size.width * .86,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          
          children: [
            SizedBox(
              width: 20,
            ),
            SvgPicture.asset(
              picture,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textScaleFactor: 1.1,
            ),
          ],
        ),
      ),
    );
  }
}
