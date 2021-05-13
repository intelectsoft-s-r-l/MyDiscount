import 'package:flutter/material.dart';

import '../../core/localization/localizations.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/profile_page_widgets/profile_home_item_widget.dart';

class InformationPage extends StatelessWidget {
  const InformationPage();
  @override
  Widget build(BuildContext context) {
    final  pageName = ModalRoute.of(context)!.settings.arguments as String?;

    return CustomAppBar(
      title: pageName,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            ProfileHomeItemWidget(
              pageName: AppLocalizations.of(context)!.translate('privacypolicy'),
              routeName: '/politicaconf',
            ),
            ProfileHomeItemWidget(
              pageName: AppLocalizations.of(context)!.translate('technicdata'),
              routeName: '/technicdetail',
            ),
            ProfileHomeItemWidget(
              pageName: AppLocalizations.of(context)!.translate('appinfo'),
              routeName: '/about',
            )
          ],
        ),
      ),
    );
  }
}
