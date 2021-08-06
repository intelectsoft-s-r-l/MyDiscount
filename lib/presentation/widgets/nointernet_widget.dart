import 'package:flutter/material.dart';

import '../../infrastructure/core/localization/localizations.dart';

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/icons/no_internet_img.png'),
          const SizedBox(height: 20.0),
          Text(
            AppLocalizations.of(context).translate('nothaveinet'),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            AppLocalizations.of(context).translate('serviceunavailable'),
            style: const TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
