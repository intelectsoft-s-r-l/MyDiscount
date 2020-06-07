import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:guid_gen/Screens/Log_in_Screen.dart';
import 'package:guid_gen/models/auth.dart';

//import 'package:guid_gen/Screens/log_or_Sign_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Credential>.value(value:Credential(),
          child: MaterialApp(
        home: LoginPage(),
      ),
    );
  }
}
