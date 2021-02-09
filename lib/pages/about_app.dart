import 'package:flutter/material.dart';

import '../core/localization/localizations.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final String pageName = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(pageName, style: const TextStyle(fontSize: 18)),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Container(
        color: Colors.green,
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.only(left: 5, right: 5),
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context).translate('text18'),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(
                        height: size.height * .45,
                        width: size.width,
                        child: Image.asset(
                          'assets/icons/1.png',
                          fit: BoxFit.fill,
                        )),
                    Text(
                      '${AppLocalizations.of(context).translate('text61')} 2.1.4',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      AppLocalizations.of(context).translate('text48'),
                      style: const TextStyle(fontSize: 15),
                    ),
                    Text(
                      AppLocalizations.of(context).translate('text49'),
                      style: const TextStyle(fontSize: 15),
                    ),
                    Text(
                      AppLocalizations.of(context).translate('text50'),
                      style: const TextStyle(fontSize: 15),
                    ),
                    Text(
                      AppLocalizations.of(context).translate('text51'),
                      style: const TextStyle(fontSize: 15),
                    ),
                    const SizedBox(
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
