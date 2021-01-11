import 'package:flutter/material.dart';

import '../core/localization/localizations.dart';

class NoInternetWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Image.asset('assets/icons/no internet.png'),
            ),
            const SizedBox(height: 20.0),
            Text(
              AppLocalizations.of(context).translate('text6'),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              AppLocalizations.of(context).translate('text7'),
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
