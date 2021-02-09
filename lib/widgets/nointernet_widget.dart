import 'package:flutter/material.dart';

import '../core/localization/localizations.dart';

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/icons/no internet.png'),
          const SizedBox(height: 20.0),
          Text(
            AppLocalizations.of(context).translate('text6'),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            AppLocalizations.of(context).translate('text7'),
            style: const TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
