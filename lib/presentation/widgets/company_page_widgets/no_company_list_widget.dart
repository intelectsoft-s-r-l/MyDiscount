import 'package:flutter/material.dart';

import '../../../infrastructure/core/localization/localizations.dart';

class NoCompanyList extends StatelessWidget {
  const NoCompanyList({Key? key}) : super(key: key);

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
            'assets/icons/company_icon.jpg',
            scale: 1.2,
          ),
          Text(
            AppLocalizations.of(context)!.translate('companylist')!,
            style:const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
         const SizedBox(
            height: 20,
          ),
          Text(
            AppLocalizations.of(context)!.translate('nocompany')!,
            style:const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
