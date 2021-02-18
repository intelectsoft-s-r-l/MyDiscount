import 'dart:async';

import 'package:MyDiscount/pages/qr_page.dart';
import 'package:MyDiscount/widgets/bottom_navigator/ripple_animation.dart';
import 'package:flutter/material.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../core/localization/localizations.dart';

import '../pages/home_page.dart';
import '../pages/notification_page.dart';


class BottomNavigationBarWidget extends StatefulWidget {
  @override
  _BottomNavigationBarWidgetState createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget>
    with WidgetsBindingObserver {
  int selectedIndex = 1;
  final StreamController _indexController = StreamController();
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  @override
  void dispose() {
    _indexController.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: [
        HomePage(),
        QrPage(),
        NotificationPage(),
      ].elementAt(selectedIndex),
      bottomNavigationBar: StreamBuilder(
        stream: _indexController.stream,
        builder: (context, snapshot) => SafeArea(
          top: true,
          bottom: true,
          maintainBottomViewPadding: true,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    width: 2,
                    color: Colors.grey[200],
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[200],
                    blurRadius: 0.1,
                    spreadRadius: 1.5,
                  )
                ]),
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
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * .33,
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
                            color: snapshot.data == 0
                                ? Colors.green
                                : Colors.black,
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
                      child: const RipplesAnimation(),
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
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * .33,
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
                            color: snapshot.data == 2
                                ? Colors.green
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
