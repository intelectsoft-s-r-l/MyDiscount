import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import '../core/localization/localizations.dart';

class AboutAppPage extends StatefulWidget {
  @override
  _AboutAppPageState createState() => _AboutAppPageState();
}

class _AboutAppPageState extends State<AboutAppPage> {
  String appversion;
  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((pack) {
      setState(() {
        appversion = pack.version;
      });
    });
  }

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
                      AppLocalizations.of(context).translate('welcome'),
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
                      '${AppLocalizations.of(context).translate('appversion')} $appversion',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      AppLocalizations.of(context).translate('aboutpar.1'),
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      AppLocalizations.of(context).translate('aboutpar.2'),
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      AppLocalizations.of(context).translate('aboutpar.3'),
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      AppLocalizations.of(context).translate('aboutpar.4'),
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
