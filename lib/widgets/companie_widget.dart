import 'dart:convert';

import 'package:MyDiscount/models/company_model.dart';
import 'package:flutter/material.dart';

import '../localization/localizations.dart';

class CompanyWidget extends StatelessWidget {
  const CompanyWidget(this.company);
  final Company company;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(top: 10, bottom: 10,right: 5,left: 5),
      leading: Container(
        width: 60,
        height: 60,
        //TODO de plasat in decoder pentru a taia tegurile care vin de la web cabinet 
        /* .toString().characters.skip(22) */
        child: Image.memory(
            Base64Decoder().convert('${company.logo.toString().characters.skip(22)}'),
            filterQuality: FilterQuality.high,
            fit: BoxFit.contain,
            errorBuilder: (context,obj,_)=>Container(),
          ),
        ),
 
      title: FittedBox(fit: BoxFit.scaleDown,
              child: Text(
          '${company.name}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      //se va adauga in alta versiune
      /* subtitle: Text('Index:${companie['Index']}'), */
      trailing: Container(
        width: 80,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              AppLocalizations.of(context).translate('text11'),
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
            FittedBox(fit:BoxFit.contain,
                          child: Text(
                '${double.parse(company.amount).toStringAsFixed(2) } lei',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
