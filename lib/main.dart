import 'package:flutter/material.dart';
import './Screens/Home_screen.dart';
import './Screens/companii.dart';
import './Screens/info_screen.dart';

import './Screens/Log_in_Screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
 bool isLogin= false;
  int _selectedIndex = 0;
  void _onitemtaped(int index) {
    setState(() {
      _selectedIndex = index;
      
    });
  }

  @override
  Widget build(BuildContext context) {
    

    return   MaterialApp(
      /*  initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
         '/home': (context) => HomeScreen(),
      },  */
      home: Scaffold(
        body:[HomeScreen(), Companies(), Info()]
            .elementAt(_selectedIndex),
        bottomNavigationBar:isLogin? LoginPage(): BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onitemtaped,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              title: Text('Home'),
              icon: Icon(
                Icons.home,
              ),
            ),
            BottomNavigationBarItem(
              title: Text('Companii'),
              icon: Icon(Icons.person_pin),
            ),
            BottomNavigationBarItem(
              title: Text('Info'),
              icon: Icon(Icons.info_outline),
            ),
          ],
        )
      ),
    );
  }
}
