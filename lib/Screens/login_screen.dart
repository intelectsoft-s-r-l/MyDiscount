import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../main.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var data = Provider.of<AuthService>(context);

    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(240, 242, 241, 1),
      ),
      child: Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 3,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.7,
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'Sign In',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: GestureDetector(
                        onTap: () {
                          data.logwithG();
                        },
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.green,
                          child: Text(
                            'G',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 45),
                          ), /* Image.asset(
                            'assets/icons/google.png',
                            
                            scale: 0.7,
                          ), */
                        ),
                      ),
                    ),
                    SizedBox(width: 40),
                    Container(
                      child: GestureDetector(
                        onTap: () {
                          data.authWithFacebook().whenComplete(
                            () {
                              main();
                            },
                          );
                        },
                        child: CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.green,
                            child: Text(
                              'f',
                              style: TextStyle(
                                  fontSize: 45,
                                  color: Colors.white,
                                  /* Color.fromRGBO(65, 90, 147, 1), */
                                  fontWeight: FontWeight.bold),
                            )
                            /* Container(
                            constraints: BoxConstraints.expand(
                              width: 28,
                              height: 28,
                            ),
                            decoration: BoxDecoration(color: Colors.white),
                            child:  */
                            /*   Image.asset(
                            'assets/icons/fac.png',
                            scale: 0.6, */
                            //color: Color.fromRGBO(65, 90, 147, 1),
                            // width: 40,
                            // height: 40,
                            //),
                            //),
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
