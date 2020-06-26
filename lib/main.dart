import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './Screens/Log_in_Screen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import './Screens/Home_screen.dart';
import './Screens/companii.dart';
import './Screens/info_screen.dart';
import 'models/auth_to_service.dart';
//import 'models/remote_Config.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   try {
     RemoteConfig remoteConfig = RemoteConfig();
   remoteConfig.fetch();
   remoteConfig.activateFetched();
   } on FetchThrottledException catch (e) {
     print(e);
   } catch(e){
     print(e);
   }
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    AuthServ serv = AuthServ();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: serv.tryAutoLogin(),
        builder: (context, snapshot) => snapshot.hasData && snapshot.data
            ? MyBottomNavigationBar()
            : LoginPage(),
      ),
    );
  }
}

class MyBottomNavigationBar extends StatefulWidget {
  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _selectedIndex = 0;
  void _onitemtaped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [HomeScreen(), Companies(), Info()].elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Color.fromRGBO(42, 86, 198, 1),
        currentIndex: _selectedIndex,
        onTap: _onitemtaped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              title: Text(
                'Qr',
              ),
              icon: Icon(MdiIcons.qrcode)),
          BottomNavigationBarItem(
            title: Text(
              'Companies',
            ),
            icon: Icon(
              Icons.person_pin,
            ),
          ),
          BottomNavigationBarItem(
            title: Text(
              'Info',
            ),
            icon: Icon(
              Icons.info_outline,
            ),
          ),
        ],
      ),
    );
  }
}
