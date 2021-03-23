import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/localization/localizations.dart';
import '../../injectable.dart';
import '../../main.dart';
import '../../providers/news_settings.dart';
import '../../services/fcm_service.dart';
import '../widgets/custom_app_bar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    void _changeLanguage(Language language) async {
      final Locale _locale =
          await AppLocalizations.of(context).setLocale(language.languageCode);
      MyApp.setLocale(context, _locale);
      InitApp.setLocale(context, _locale);
    }

    return CustomAppBar(
      title: AppLocalizations.of(context).translate('settings'),
      child: Container(
        color: Colors.white,
        child: ChangeNotifierProvider<FirebaseCloudMessageService>.value(
          value: getIt<FirebaseCloudMessageService>(),
          child: ChangeNotifierProvider<NewsSettings>.value(
            value: NewsSettings(),
            child: Column(
              children: [
                Consumer2(
                  builder: (context, FirebaseCloudMessageService provider,
                      NewsSettings provider2, _) {
                    return Column(
                      children: [
                        ListTile(
                          title: Text(
                            AppLocalizations.of(context)
                                .translate('notificationsettings'),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                          trailing: Switch(
                              value: provider.isActivate,
                              onChanged: (newValue) {
                                provider.isActivate = newValue;
                              }),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Divider(),
                        ),
                        ListTile(
                          title: Text(
                            AppLocalizations.of(context).translate('news'),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                          trailing: Switch(
                              value: provider2.isActivate,
                              onChanged: (newValue) {
                                provider2.isActivate = newValue;
                              }),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Divider(),
                        ),
                      ],
                    );
                  },
                ),
                Container(
                  width: size.width,
                  padding: EdgeInsets.only(right: 10),
                  child: ListTile(
                    title: Text(
                      AppLocalizations.of(context).translate('lang'),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
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
