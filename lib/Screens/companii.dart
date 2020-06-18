import 'package:flutter/material.dart';

import 'Log_in_Screen.dart';

class Companies extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(42, 86, 198, 1),
        title: Text(
          'Companies',
          style: TextStyle(fontSize: 30),
        ),actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              /* signoutFb();
              signOut(); */
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        child: Text('data'),
      ),
    );
  }
}
