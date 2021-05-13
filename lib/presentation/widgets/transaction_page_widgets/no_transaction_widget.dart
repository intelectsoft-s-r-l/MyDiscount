import 'package:flutter/material.dart';
import 'package:my_discount/core/localization/localizations.dart';

class NoTransactionWidget extends StatelessWidget {
  const NoTransactionWidget({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size.width,
        height: size.width,
        child: Stack(
          children: [
            Positioned(
              top: size.width * .15,
              left: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * .6,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Image.asset(
                    'assets/icons/no_transaction.png',
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: size.width * .65,
              child: Container(
                width: size.width,
                child: Text(AppLocalizations.of(context)!.translate('notransactions')!,
                    style:const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
