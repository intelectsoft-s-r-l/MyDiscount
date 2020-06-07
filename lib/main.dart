import 'package:flutter/material.dart';

import 'package:guid_gen/Screens/Log_in_Screen.dart';

//import 'package:guid_gen/Screens/log_or_Sign_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return /* ChangeNotifierProvider<User>.value(
          value:,
          child: */ MaterialApp(
          home: LoginPage(),
       // ),
    );
  }
}
