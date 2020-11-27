import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/companies_screen.dart';
import '../Screens/info_screen.dart';
import '../Screens/login_screen.dart';
import '../Screens/qr_screen.dart';
import '../services/auth_service.dart';
import '../services/fcm_service.dart';
//import '../services/qr_service.dart';
import '../widgets/app_bar_icons.dart';
import '../widgets/app_bar_text.dart';
//import '../widgets/drawer.dart';

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  //GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  StreamController<int> _indexController = StreamController.broadcast();

  PageController _pageController;

  //static QrService _qrService = QrService();

  int selectedIndex = 0;
  @override
  void initState() {
    _pageController = PageController(
      initialPage: 1,
    );
    selectedIndex = _pageController.initialPage;
    getAuthState();
    super.initState();
  }

  getAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('credentials')) authController.sink.add(true);
  }

  @override
  void dispose() {
    _indexController.close();
    fcmService.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthService data = AuthService();
    var size = MediaQuery.of(context).size;

    /* void _openDrawer() {
      _scaffoldKey.currentState.openDrawer();
    } */

    return Scaffold(
      drawerEnableOpenDragGesture: false,
      drawerEdgeDragWidth: 60,
      // key: _scaffoldKey,
      /* drawer: Drawer(
        child: FutureBuilder(
            future: fcmService.getListofNotification(),
            builder: (context, snapshot) => DrawerWidget(snapshot.data)),
      ), */
      backgroundColor: Color.fromRGBO(240, 242, 241, 1),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0, 1),
                  blurRadius: 2,
                )
              ],
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            height: size.height * .25,
            width: double.infinity,
            child: Stack(
              children: <Widget>[
                /*  Positioned(
                  top: size.height * .04,
                  left: size.width * .06,
                  child: Container(
                    child: IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        _openDrawer();
                      },
                    ),
                  ),
                ), */
                Positioned(
                  top: size.height * .06,
                  left: size.width * .33,
                  child: Container(
                    alignment: Alignment.center,
                    width: size.width * .33,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        "MyDiscount",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: size.height * .045,
                  right: 10,
                  child: IconButton(
                      color: Colors.green,
                      icon: Icon(MdiIcons.locationExit),
                      onPressed: () {
                        data.signOut();
                        _pageController.jumpToPage(
                          1,
                          /*  duration: Duration(
                              milliseconds: 50,
                            ),
                            curve: Curves.ease */
                        );
                        authController.add(false);
                        setState(() {});
                      }),
                ),
                AppBarIcons(
                    size: size,
                    indexController: _indexController,
                    selectedIndex: selectedIndex,
                    pageController: _pageController),
                AppbarText(size: size),
              ],
            ),
          ),
          StreamBuilder<bool>(
            initialData: false,
            stream: authController.stream, //_qrService.tryAutoLogin(),
            builder: (context, snapshot) => Expanded(
              child: PageView(
                dragStartBehavior: DragStartBehavior.down,
                pageSnapping: true,
                onPageChanged: (value) async {
                  _indexController.add(selectedIndex = value);
                },
                allowImplicitScrolling: false,
                controller: _pageController,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(240, 242, 241, 1),
                    ),
                    width: size.width * 0.9,
                    height: size.height * 0.6,
                    child: Companies(),
                  ),
                  snapshot.data == true ? QrScreen() : LoginPage(),
                  InfoScreen(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
