import 'dart:async';

import 'package:flutter/material.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../core/localization/localizations.dart';
import '../new_button/ripple_animation.dart';
import '../pages/home_page.dart';
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
  StreamController _indexController = StreamController();
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  /* @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(mounted)
    if (state == AppLifecycleState.resumed) {
      Navigator.of(context).pushReplacementNamed('/app');
    }
    super.didChangeAppLifecycleState(state);
  } */

  @override
  void dispose() {
    _indexController.close();
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
        bottomNavigationBar: StreamBuilder(
          stream: _indexController.stream,
          builder: (context, snapshot) => Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Colors.grey[200],
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[200],
                    blurRadius: 0.1,
                    spreadRadius: 1.0,
                  )
                ]),
            //color: Colors.red,
            height: 60,
            child: Row(
              children: [
                InkResponse(
                  onTap: () {
                    setState(() {
                      selectedIndex = 0;
                      _indexController.add(0);
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * .33,
                    // color: Colors.green,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home,
                          color:
                              snapshot.data == 0 ? Colors.green : Colors.black,
                        ),
                        Text(
                          AppLocalizations.of(context).translate('text21'),
                          style: TextStyle(
                            color:
                                snapshot.data == 0 ? Colors.green : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),        
                Expanded(
                  child: InkResponse(
                    onTap: () {
                      setState(() {
                        _indexController.add(1);
                        selectedIndex = 1;
                      });
                    },
                    child: Container(
                      alignment: Alignment.topCenter,
                      color: Colors.white,
                      child: RipplesAnimation(),
                    ),
                  ),
                ),
                InkResponse(
                  onTap: () {
                    setState(() {
                      selectedIndex = 2;
                      _indexController.add(2);
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * .33,
                    //color: Colors.amber,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                           MdiIcons.newspaper,
                          color:
                              snapshot.data == 2 ? Colors.green : Colors.black,
                        ),
                        Text(
                          AppLocalizations.of(context).translate('text23'),
                          style: TextStyle(
                            color:
                                snapshot.data == 2 ? Colors.green : Colors.black,
                            //fontSize: snapshot.data == 2?15:10
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ) /* BottomNavigationBar(
        /* type: BottomNavigationBarType.shifting, */
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
          /* BottomNavigationBarItem(
            icon: Icon(
              MdiIcons.qrcode,
              color: Colors.black,
            ),
            label: 'QR',
          ), */
          BottomNavigationBarItem(
              icon: Icon(
                Icons.notifications,
                color: Colors.black,
              ),
              label: AppLocalizations.of(context).translate('text23')),
        ],
      ), */
        );
  }
}
