import 'package:flutter/material.dart';

import '../core/localization/localizations.dart';

class NoCompanieList extends StatelessWidget {
  const NoCompanieList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          Image.asset(
            'assets/icons/companie.jpg',
            scale: 1.2,
          ),
          Text(
            AppLocalizations.of(context).translate('text13'),
            style:const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
         const SizedBox(
            height: 20,
          ),
          Text(
            AppLocalizations.of(context).translate('text14'),
            style:const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
