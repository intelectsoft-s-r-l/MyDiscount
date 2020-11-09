import 'dart:convert';

import 'package:flutter/material.dart';

import 'localizations.dart';

class CompanieWidget extends StatelessWidget {
  const CompanieWidget(this.companie);
  final companie;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(top: 10, bottom: 10,right: 5,left: 5),
      leading: Container(
        width: 60,
        height: 60,
        child: Image.memory(
            Base64Decoder().convert('${companie['Logo']}'),
            filterQuality: FilterQuality.high,
            fit: BoxFit.contain,
          ),
        ),
 
      title: FittedBox(fit: BoxFit.scaleDown,
              child: Text(
          '${companie['Name']}',
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
                '${double.parse(companie['Amount']).toStringAsFixed(2) } lei',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
