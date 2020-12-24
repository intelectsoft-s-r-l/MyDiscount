
import 'package:MyDiscount/localization/localizations.dart';
import 'package:MyDiscount/widgets/home_page_top_widget.dart';
import 'package:MyDiscount/widgets/profile_home_item_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.green,
      body: Column(
        children: [
          HomePageTopWidget(size: size),
          Expanded(
            child: Container(
              height: size.height * .7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  ProfileHomeItemWidget(
                    icon: Icons.account_circle_outlined,
                    pageName:  AppLocalizations.of(context).translate('text25'),
                    routeName: '/profilepage',
                  ),
                  ProfileHomeItemWidget(
                    icon: Icons.apartment_outlined,
                    pageName:  AppLocalizations.of(context).translate('companies'),
                    routeName: '/companypage',
                  ),
                  ProfileHomeItemWidget(
                    icon: Icons.transfer_within_a_station_outlined,
                    pageName:  AppLocalizations.of(context).translate('text22'),
                    routeName: '/transactionlist',
                  ),
                  ProfileHomeItemWidget(
                    icon: Icons.info_outline,
                    pageName:  AppLocalizations.of(context).translate('Info'),
                    routeName: '/infopage',
                  ),
                  ProfileHomeItemWidget(
                    icon: Icons.settings,
                    pageName:  AppLocalizations.of(context).translate('text24'),
                    routeName: '/settings',
                  ),
                  
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}