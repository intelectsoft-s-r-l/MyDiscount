import 'package:flutter/material.dart';

import '../widgets/localizations.dart';

class InfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topLeft,
        child: Center(
          child: Text(
            AppLocalizations.of(context).translate('Info'),
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
