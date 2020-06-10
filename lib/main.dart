import 'package:flutter/material.dart';

//import 'models/vremenno.dart';

import 'package:guid_gen/Screens/Log_in_Screen.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
          home: LoginPage(),
       // ),
    );
  }
}