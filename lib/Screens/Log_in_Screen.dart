import 'package:flutter/material.dart';
import 'package:guid_gen/models/auth.dart';
import 'package:provider/provider.dart';


import 'Home_screen.dart';
import 'Sign_in_Screen.dart';

class LoginPage extends StatefulWidget {
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
          title: Text('Log In'),
        ),
        body: Center(
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
                RaisedButton(
                  color: Colors.blue,
                  child: Text('Login'),
                  onPressed: () {},
                ),
                FlatButton(
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onPressed: () {
                    Provider.of<Credential>(context, listen: false)
                        .authFb();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                    );
                  },
                  child: Text('Login with Facebook'),
                ),
                FlatButton(
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onPressed: () {
                    Provider.of<Credential>(context, listen: false)
                        .logwithG();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                    );
                  },
                  child: Text('Login with Google'),
                ),
                GestureDetector(
                  child: Text('Create an Account'),
                  onTap: () {Provider.of<Credential>(context).logwithG();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => SignInScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
