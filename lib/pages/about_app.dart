
import 'package:flutter/material.dart';

import '../core/localization/localizations.dart';

class AboutAppPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final String pageName = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(pageName, style: TextStyle(fontSize: 18)),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Container(
        color: Colors.green,
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Container(
              padding: EdgeInsets.only(left: 5, right: 5),
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context).translate('text18'),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Container(
                        height: size.height * .45,
                        width: size.width,
                        child: Image.asset(
                          'assets/icons/1.png',
                          fit: BoxFit.fill,
                        )),
                    Text(
                      '${AppLocalizations.of(context).translate('text61')} 2.1.2',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      AppLocalizations.of(context).translate('text48'),
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      AppLocalizations.of(context).translate('text49'),
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      AppLocalizations.of(context).translate('text50'),
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      AppLocalizations.of(context).translate('text51'),
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Image.asset(
                      'assets/icons/islogo.jpeg',
                      fit: BoxFit.fill,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
