import 'package:MyDiscount/localization/localizations.dart';
import 'package:MyDiscount/main.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final val = true;
  //final local = AppLocalizations.delegate.load(Locale('ru_RU'));
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    //final String pageName = ModalRoute.of(context).settings.arguments;
    _changeLanguage(Language language) async {
      Locale _locale =
          await AppLocalizations.of(context).setLocale(language.languageCode);
      MyApp.setLocale(context, _locale);
      //AppLocalizations.of(context).getLocale();
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
                  val: val,
                  name: AppLocalizations.of(context).translate('text29'),
                  size: size,
                ),
                SettingsItemWidget(
                  val: val,
                  name: AppLocalizations.of(context).translate('text23'),
                  size: size,
                ),
                Container(
                  width: size.width,
                  //height: 61,
                  padding: EdgeInsets.only(right: 10),
                  child: ListTile(
                    title: Text(
                      AppLocalizations.of(context).translate('text38'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20
                      ),
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

class SettingsItemWidget extends StatelessWidget {
  const SettingsItemWidget({Key key, @required this.val, this.name, this.size})
      : super(key: key);
  final String name;
  final bool val;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width, height: 72,
      //padding: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20
              ),
            ),
            trailing: Switch(
                value: val,
                onChanged: (newValue) {
                  newValue = val;
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
