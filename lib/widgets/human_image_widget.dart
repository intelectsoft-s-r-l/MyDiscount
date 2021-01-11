import 'package:flutter/material.dart';

import '../core/localization/localizations.dart';

class HumanImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Image.asset(
              'assets/icons/om.png',
              scale: 0.5,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            AppLocalizations.of(context).translate('text3'),
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            AppLocalizations.of(context).translate('text4'),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
