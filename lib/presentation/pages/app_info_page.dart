import 'package:flutter/material.dart';

import '../widgets/app_info_widget.dart';
import '../widgets/custom_app_bar.dart';

import '../../core/localization/localizations.dart';

class AppInfoPage extends StatelessWidget {
  const AppInfoPage();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return CustomAppBar(
      title: AppLocalizations.of(context).translate('privacypolicy'),
      child: Container(
        color: Colors.white,
        child: AppInfoWidget(size: size),
      ),
    );
  }
}
