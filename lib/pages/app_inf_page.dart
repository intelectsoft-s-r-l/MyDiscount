import 'package:flutter/material.dart';

import '../core/localization/localizations.dart';
import '../widgets/app_info_widget.dart';

class AppInfoPage extends StatelessWidget {
  const AppInfoPage();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('text32'),
          style: const TextStyle(fontSize: 18),
        ),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Container(
        color: Colors.green,
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Container(
              color: Colors.white,
              child: AppInfoWidget(size: size),
            ),
          ),
        ),
      ),
    );
  }
}
