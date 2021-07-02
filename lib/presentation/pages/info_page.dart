import 'package:flutter/material.dart';
import 'package:my_discount/presentation/widgets/home_page/home_item_widget.dart';

import '../widgets/custom_app_bar.dart';

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
            const HomeItemWidget(
              localisationKey: 'privacypolicy',
              routeName: '/politicaconf',
            ),
            const HomeItemWidget(
              localisationKey: 'technicdata',
              routeName: '/technicdetail',
            ),
            const HomeItemWidget(
              localisationKey: 'appinfo',
              routeName: '/about',
            )
          ],
        ),
      ),
    );
  }
}
