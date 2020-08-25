import 'dart:convert';

import 'package:MyDiscount/widgets/localizations.dart';
import 'package:flutter/material.dart';

class CompanieWidget extends StatelessWidget {
  const CompanieWidget(this.companie);
  final companie;

  @override
  Widget build(BuildContext context) {
    return ListTile(
          contentPadding: EdgeInsets.only(top:10,bottom: 10),
          leading: Container(
              width: 80,
              height: 80,
              child: Image.memory(
                Base64Decoder().convert('${companie['Logo']}'),
              )),
          title: Text(
            '${companie['Name']}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
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
                Text(
                  '${companie['Amount']} lei',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
  }
}