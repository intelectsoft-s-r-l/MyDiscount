import 'package:flutter/material.dart';

import '../core/localization/localizations.dart';
import '../widgets/profile_home_item_widget.dart';

class InformationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final String pageName = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(pageName),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Container(
        color: Colors.green,
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Container(
            width: size.width,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  ProfileHomeItemWidget(
                    pageName: AppLocalizations.of(context).translate('privacypolicy'),
                    routeName: '/politicaconf',
                  ),
                  ProfileHomeItemWidget(
                    pageName: AppLocalizations.of(context).translate('technicdata'),
                    routeName: '/technicdetail',
                  ),
                  ProfileHomeItemWidget(
                    pageName: AppLocalizations.of(context).translate('appinfo'),
                    routeName: '/about',
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
