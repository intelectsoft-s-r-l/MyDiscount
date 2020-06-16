import 'package:flutter/material.dart';
import 'package:guid_gen/Screens/Log_in_Screen.dart';
import './Screens/Home_screen.dart';
import './Screens/companii.dart';
import './Screens/info_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: LoginPage());
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
      ),
    );
  }
}
