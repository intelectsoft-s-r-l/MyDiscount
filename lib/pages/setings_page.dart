import 'package:MyDiscount/pages/app_inf_page.dart';
import 'package:MyDiscount/pages/login_screen2.dart';
import 'package:MyDiscount/pages/notifications_settings_page.dart';
import 'package:MyDiscount/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SetingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  child: SvgPicture.asset(
                    'assets/icons/top.svg',
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  top: size.height * .08,
                  left: size.width * .33,
                  child: Container(
                    width: size.width * .33,
                    alignment: Alignment.center,
                    child: Text(
                      'Settings',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Accounts Details',
                          style: TextStyle(fontSize: 25),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    indent: 70,
                    color: Colors.grey,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationSettingsPage(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.notifications,
                          size: 50,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Notifications settings',
                          style: TextStyle(fontSize: 25),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    indent: 70,
                    color: Colors.grey,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AppInfoPage(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.info,
                          size: 50,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'App Info',
                          style: TextStyle(fontSize: 25),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    indent: 70,
                    color: Colors.grey,
                  ),
                  //Spacer(),
                  Container(
                    height: size.height * .35,
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Positioned(
                          bottom: 10,
                          child: Container(
                            child: FlatButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen2(),
                                  ),
                                );
                              },
                              child: Container(
                                width: size.width * .8,
                                padding: EdgeInsets.all(5),
                                height: 45,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blueGrey[50]),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.logout,
                                      color: Colors.black,
                                    ),
                                    Container(
                                      width: size.width * .6,
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Log Out',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
