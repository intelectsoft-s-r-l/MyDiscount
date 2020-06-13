import 'package:flutter/material.dart';
import 'package:guid_gen/models/facebook_auth.dart';
import 'package:guid_gen/models/google_auth.dart';


class LoginPage extends StatefulWidget {
  static const routeName = '/';
  @override
  _StateLoginPage createState() => _StateLoginPage();
}

class _StateLoginPage extends State<LoginPage> {
  var isLogin = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(42, 86, 198, 1),
          title: Text(
            'Y-Qr',
            style: TextStyle(fontSize: 30),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left:8.0,top: 8.0),
                      child: Text(
                        'Welcome,',
                        style:
                            TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:8.0,),
                      child: Text('Register to continue',
                          style: TextStyle(color: Colors.black45)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 130),
              Center(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 3,
                            color: Colors.blue,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.email,
                            ),
                            labelText: 'E-mail',
                          ),
                          /* validator: (value) {
              if (value.isEmpty || !value.contains('@')) {
    return 'Invalid Email';
              }
      },
      onSaved: (value) {
              _authData['email'] = value;
      }, */
                        ),
                      ),
                      // Text('data'),
                      Divider(),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 3,
                            color: Colors.blue,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.lock,
                            ),
                            labelText: 'Password',
                          ),
                          /*  validator: (value) {
              if (value.isEmpty || value.length < 5) {
    return 'Invalid Password';
              }
      }, */
                          /*  onSaved: (value) {
              _authData['pw'] = value;
      }, */
                        ),
                      ),
                      SizedBox(height: 30,),
                      RaisedButton(
                        color: Color.fromRGBO(42, 86, 198, 1),
                        child: Text(
                          'Register',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        onPressed: () {},
                      ),
                      Text(
                        'Register with:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 30),
                    GAuth(),
                      FbAuth(),
                     
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
