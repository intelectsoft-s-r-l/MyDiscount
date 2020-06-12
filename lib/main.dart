import 'package:flutter/material.dart';

//import 'models/vremenno.dart';

import 'package:guid_gen/Screens/Log_in_Screen.dart';
import 'package:guid_gen/models/auth_to_service.dart';
import 'package:provider/provider.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  ChangeNotifierProvider.value(value: AuthServ(),
          child: MaterialApp(
            home: LoginPage(),
         // ),
      ),
    );
  }
}