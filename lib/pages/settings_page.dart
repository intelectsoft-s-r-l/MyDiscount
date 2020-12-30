import 'dart:async';

import 'package:flutter/material.dart';

import '../localization/localizations.dart';
import '../main.dart';

class SettingsPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    _changeLanguage(Language language) async {
      Locale _locale =
          await AppLocalizations.of(context).setLocale(language.languageCode);
      MyApp.setLocale(context, _locale);
      
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('text24')),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Container(
        color: Colors.green,
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              color: Colors.white,
            ),
            child: Column(
              children: [
                SettingsItemWidget(
                  name: AppLocalizations.of(context).translate('text29'),
                  size: size,
                ),
                SettingsItemWidget(
                  name: AppLocalizations.of(context).translate('text23'),
                  size: size,
                ),
                Container(
                  width: size.width,
                  
                  padding: EdgeInsets.only(right: 10),
                  child: ListTile(
                    title: Text(
                      AppLocalizations.of(context).translate('text38'),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    trailing: FutureBuilder<Language>(
                      future: AppLocalizations.of(context).getLanguage(),
                      builder: (context, snapshot) => DropdownButton<Language>(
                        underline: Container(),
                        hint: Container(
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 5),
                            height: 20,
                            width: 120,
                            child: snapshot.hasData
                                ? Text('${snapshot.data.name}')
                                : Container()),
                        items: Language.languageList()
                            .map<DropdownMenuItem<Language>>(
                                (lang) => DropdownMenuItem(
                                      value: lang,
                                      child: Row(
                                        children: [
                                          Text(
                                            lang.flag,
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(lang.name),
                                        ],
                                      ),
                                    ))
                            .toList(),
                        onChanged: (Language language) {
                          _changeLanguage(language);
                        },
                        icon: Icon(Icons.language),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Divider(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

StreamController<bool> controller = StreamController<bool>.broadcast();

class SettingsItemWidget extends StatefulWidget {
  const SettingsItemWidget({Key key, this.name, this.size}) : super(key: key);
  final String name;

  final Size size;
  @override
  _SettingsItemWidgetState createState() => _SettingsItemWidgetState();
}

class _SettingsItemWidgetState extends State<SettingsItemWidget> {
  bool val = true;
  @override
  void dispose() {
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size.width, height: 72,
      
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            trailing: Switch(
                value: val,
                onChanged: (newValue) {
                  setState(() {
                    val = newValue;
                    
                  });
                }),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Divider(),
          ),
        ],
      ),
    );
  }
}
