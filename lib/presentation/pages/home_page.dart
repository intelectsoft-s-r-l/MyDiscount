import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../aplication/auth/auth_bloc.dart';
import '../../infrastructure/core/localization/localizations.dart';
import '../widgets/home_page_top_widget.dart';
import '../widgets/profile_home_item_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage();
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.green,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthorized) {
            Navigator.pushReplacementNamed(context, '/login');
          }
        },
        child: Column(
          children: [
            HomePageTopWidget(
              size: size,
            ),
            Expanded(
              child: Container(
                height: size.height * .7,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  color: Colors.white,
                ),
                child: ListView(
                  //physics: BouncingScrollPhysics(),
                  children: [
                    ProfileHomeItemWidget(
                      icon: Icons.account_circle_outlined,
                      pageName: AppLocalizations.of(context)!
                          .translate('profile') as String,
                      routeName: '/profilepage',
                    ),
                    ProfileHomeItemWidget(
                      icon: Icons.apartment_outlined,
                      pageName: AppLocalizations.of(context)!
                          .translate('companies') as String,
                      routeName: '/companypage',
                    ),
                    ProfileHomeItemWidget(
                      icon: Icons.card_giftcard_outlined,
                      pageName: AppLocalizations.of(context)!
                          .translate('mycards') as String,
                      routeName: '/cardlist',
                    ),
                    ProfileHomeItemWidget(
                      icon: Icons.transfer_within_a_station_outlined,
                      pageName: AppLocalizations.of(context)!
                          .translate('transactions') as String,
                      routeName: '/transactionlist',
                    ),
                    ProfileHomeItemWidget(
                      icon: Icons.info_outline,
                      pageName: AppLocalizations.of(context)!.translate('Info')
                          as String,
                      routeName: '/infopage',
                    ),
                    ProfileHomeItemWidget(
                      icon: Icons.settings,
                      pageName: AppLocalizations.of(context)!
                          .translate('settings') as String,
                      routeName: '/settings',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
