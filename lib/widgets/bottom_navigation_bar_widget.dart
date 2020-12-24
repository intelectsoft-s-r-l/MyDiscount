import 'package:MyDiscount/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../localization/localizations.dart';
import '../pages/notification_page.dart';
import '../pages/qr-page.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  @override
  _BottomNavigationBarWidgetState createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget>
    with WidgetsBindingObserver {
  int selectedIndex = 1;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
   
    /* if (state == AppLifecycleState.resumed) {
       Navigator.of(context).pushReplacementNamed('/app');
    }  */
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        HomePage(),
        QrPage(),
        NotificationPage(),
      ].elementAt(selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        unselectedFontSize: MediaQuery.of(context).devicePixelRatio + 6,
        selectedFontSize: MediaQuery.of(context).devicePixelRatio + 8,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        currentIndex: selectedIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.black,
              ),
              label: AppLocalizations.of(context).translate('text21')),
          BottomNavigationBarItem(
            icon: Icon(
              MdiIcons.qrcode,
              color: Colors.black,
            ),
            label: 'QR',
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.notifications,
                color: Colors.black,
              ),
              label: AppLocalizations.of(context).translate('text23')),
        ],
      ),
    );
  }
}
