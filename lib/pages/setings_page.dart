import '../localization/localizations.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../widgets/top_bar_image.dart';
import '../widgets/top_bar_text.dart';
import 'app_inf_page.dart';
import 'notifications_settings_page.dart';
import 'profile_page.dart';
class SetingsPage extends StatelessWidget {
  final AuthService service = AuthService();
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
                TopBarImage(size: size),
                AppBarText(size: size, text: AppLocalizations.of(context).translate('text24')),
              ],
            ),
            Container(
              height: size.height*.5,
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
                          size: 40,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          AppLocalizations.of(context).translate('text28'),textScaleFactor: 1,
                          //style: TextStyle(fontSize: 25),
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
                          size: 40,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          AppLocalizations.of(context).translate('text29'),textScaleFactor: 1,
                         // style: TextStyle(fontSize: 25),
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
                          size: 40,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          AppLocalizations.of(context).translate('text30'),textScaleFactor: 1,
                         // style: TextStyle(fontSize: 25),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    indent: 70,
                    color: Colors.grey,
                  ),
                  //Spacer(),
                 
                ],
              ),
            ),
             Container(
                    height: size.height * .22,
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Positioned(
                          bottom: size.height*.02,
                          child: Container(
                            child: FlatButton(
                              onPressed: () {
                                service.signOut().whenComplete(() {
                                  Navigator.pushNamed(
                                      context, '/loginscreen');

                                  authController.add(false);
                                });
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
                                        AppLocalizations.of(context).translate('text31'),
                                        style: TextStyle(
                                            color: Colors.black,
                                            //fontSize: 20,
                                            fontWeight: FontWeight.bold),textScaleFactor: 1,
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
    );
  }
}
