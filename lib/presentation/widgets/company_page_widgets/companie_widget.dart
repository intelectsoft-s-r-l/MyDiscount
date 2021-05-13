import 'package:flutter/material.dart';
//import 'package:my_discount/presentation/pages/add_card_page.dart';

import '../../../core/localization/localizations.dart';
import '../../../domain/entities/company_model.dart';

class CompanyWidget extends StatelessWidget {
  const CompanyWidget(this.company);
  final Company company;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () {
        Navigator.pushNamed(context, '/addcard', arguments: company);
      },
      child: ListTile(
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
              Text(
                AppLocalizations.of(context)!.translate('amount')!,
                style: const TextStyle(fontWeight: FontWeight.bold),
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
      ),
    );
  }
}
