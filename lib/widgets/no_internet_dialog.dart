import 'package:MyDiscount/localization/localizations.dart';
import 'package:flutter/cupertino.dart';

getDialog(context) {
      showCupertinoDialog(
        context: (context),
        builder: (_) => CupertinoAlertDialog(
          title: Text(
            AppLocalizations.of(context).translate('text6') + '!',
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(
                AppLocalizations.of(context).translate('text8'),
                textScaleFactor: 1.5,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }