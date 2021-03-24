import 'dart:typed_data';


import 'package:flutter/material.dart';

import '../../../core/localization/localizations.dart';
import '../../../domain/entities/company_model.dart';
import '../custom_app_bar.dart';

class CompanyWidget extends StatelessWidget {
  const CompanyWidget(this.company);
  final Company company;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 5),
      leading: SizedBox(
        width: 60,
        height: 60,
        child: Image.memory(
          company.logo,
          filterQuality: FilterQuality.high,
          fit: BoxFit.contain,
          errorBuilder: (context, obj, _) => Container(),
        ),
      ),
      title: Container(
        alignment: Alignment.centerLeft,
        child: OverflowBar(
          children: [
            Text(
              '${company.name}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                //fontSize: 16,
              ),
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
      trailing: SizedBox(
        width: 80,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkResponse(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddCardPage(
                              logo: company.logo,
                              name: company.name,
                            )));
              },
              child:const Text(
                'Add Card',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ),
            Text(
              AppLocalizations.of(context).translate('amount'),
              style:const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
            FittedBox(
              fit: BoxFit.contain,
              child: Text(
                '${double.parse(company.amount).toStringAsFixed(2)} lei',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddCardPage extends StatelessWidget {
  const AddCardPage({Key key, this.logo, @required this.name})
      : assert(logo != null),
        assert(name != null),
        super(key: key);
  final Uint8List logo;
  final String name;
  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      title: 'Uneste card',
      child: Container(
        color: Colors.white,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .05,
                ),
                const Text(
                  'Compania:',
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .05,
                ),
                Expanded(
                                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        name,
                        style:const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * .05,
                  ),
                  width: 80,
                  height: 80,
                  child: Image.memory(logo),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .05,
                ),
                Text(
                  AppLocalizations.of(context).translate('inputcardnumber'),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          const  SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width * .9,
              child: TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
           const SizedBox(
              height: 10,
            ),
            ElevatedButton(onPressed: () {}, child: Text(AppLocalizations.of(context).translate('addcard')))
          ],
        ),
      ),
    );
  }
}
