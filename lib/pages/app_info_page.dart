import 'package:MyDiscount/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

import '../core/localization/localizations.dart';
import '../widgets/app_info_widget.dart';

class AppInfoPage extends StatelessWidget {
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
