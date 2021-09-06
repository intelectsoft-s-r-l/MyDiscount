import 'package:flutter/material.dart';

import 'home_item_widget.dart';

class HomePageItems extends StatelessWidget {
  const HomePageItems({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: size.height * .7,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: Colors.white,
        ),
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
            return true;
          },
          child: ListView(
            children: [
              const HomeItemWidget(
                icon: Icons.account_circle_outlined,
                localisationKey: 'profile',
                routeName: '/profilepage',
              ),
              const HomeItemWidget(
                icon: Icons.apartment_outlined,
                localisationKey: 'companies',
                routeName: '/companypage',
              ),
              const HomeItemWidget(
                icon: Icons.card_giftcard_outlined,
                localisationKey: 'mycards',
                routeName: '/cardlist',
              ),
              const HomeItemWidget(
                icon: Icons.transfer_within_a_station_outlined,
                localisationKey: 'transactions',
                routeName: '/transactionlist',
              ),
              const HomeItemWidget(
                icon: Icons.info_outline,
                localisationKey: 'Info',
                routeName: '/infopage',
              ),
              const HomeItemWidget(
                icon: Icons.settings,
                localisationKey: 'settings',
                routeName: '/settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
