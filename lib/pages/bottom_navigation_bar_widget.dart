import 'package:MyDiscount/widgets/localizations.dart';

import 'history_page.dart';
import 'notification_page.dart';
import 'qr-page.dart';
import 'setings_page.dart';
import 'user_page.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  @override
  _BottomNavigationBarWidgetState createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        UserPage(),
        TransactionsPage(),
        QrPage(),
        NotificationPage(),
        SetingsPage(),
      ].elementAt(selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        unselectedFontSize:MediaQuery.of(context).devicePixelRatio+8,
        selectedFontSize:MediaQuery.of(context).devicePixelRatio+10,
        onTap: (value) {
          if (value == 2) {
            Navigator.pushNamed(context, '/qrpage');
          } else {
            setState(() {
              if (selectedIndex != 2) {
                selectedIndex = value;
              }
            });
          }
        },
        currentIndex: selectedIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.black,
              ),
              label:AppLocalizations.of(context).translate('text21')),
          BottomNavigationBarItem(
              icon: Icon(MdiIcons.wallet, color: Colors.black),
              label: AppLocalizations.of(context).translate('text22')),
          BottomNavigationBarItem(
              icon: Icon(
                MdiIcons.qrcode,
                color: Colors.black,
              ),
              label: 'QR', ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.notifications,
                color: Colors.black,
              ),
              label: AppLocalizations.of(context).translate('text23')),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
                color: Colors.black,
              ),
              label: AppLocalizations.of(context).translate('text24') ),
        ],
      ),
    );
  }
}
