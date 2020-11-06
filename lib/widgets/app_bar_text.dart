import 'package:flutter/material.dart';

import 'widgets/localizations.dart';

class AppbarText extends StatelessWidget {
  const AppbarText({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: size.height * .020,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 10),
              alignment: Alignment.center,
              width: size.width * 0.33,
              child: Text(
                AppLocalizations.of(context).translate('companies'),
                style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: size.width * 0.33,
              child: Text(
                'QR',
                style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: size.width * 0.33,
              child: Text(
                AppLocalizations.of(context).translate('text10'),
                style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
