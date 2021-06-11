import 'package:flutter/material.dart';

import '../../infrastructure/core/localization/localizations.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/home_item_widget.dart';

class InformationPage extends StatelessWidget {
  const InformationPage();
  @override
  Widget build(BuildContext context) {
    final pageName = ModalRoute.of(context)!.settings.arguments as String?;

    return CustomAppBar(
      title: pageName,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            HomeItemWidget(
              pageName: AppLocalizations.of(context)!.translate('privacypolicy')
                  as String,
              routeName: '/politicaconf',
            ),
            HomeItemWidget(
              pageName: AppLocalizations.of(context)!.translate('technicdata')
                  as String,
              routeName: '/technicdetail',
            ),
            HomeItemWidget(
              pageName:
                  AppLocalizations.of(context)!.translate('appinfo') as String,
              routeName: '/about',
            )
          ],
        ),
      ),
    );
  }
}
