import 'package:MyDiscount/injectable.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../core/localization/localizations.dart';
import '../providers/news_settings.dart';
import '../services/fcm_service.dart';
import '../main.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    void _changeLanguage(Language language) async {
      final Locale _locale =
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
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              color: Colors.white,
            ),
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
                                    .translate('text29'),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              trailing: FutureProvider.value(
                                value:
                                    getIt<FirebaseCloudMessageService>().getFCMState(),
                                child: Switch(
                                    value: provider.isActivate,
                                    onChanged: (newValue) {
                                      provider.isActivate = newValue;
                                    }),
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: const Divider(),
                            ),
                            ListTile(
                              title: Text(
                                AppLocalizations.of(context)
                                    .translate('text23'),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              trailing: Switch(
                                  value: provider2.isActivate,
                                  onChanged: (newValue) {
                                    provider2.isActivate = newValue;
                                  }),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: const Divider(),
                            ),
                          ],
                        );
                      },
                    ),
                    Container(
                      width: size.width,
                      padding: const EdgeInsets.only(right: 10),
                      child: ListTile(
                        title: Text(
                          AppLocalizations.of(context).translate('text38'),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        trailing: FutureBuilder<Language>(
                          future: AppLocalizations.of(context).getLanguage(),
                          builder: (context, snapshot) =>
                              DropdownButton<Language>(
                            underline: Container(),
                            hint: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 5),
                                height: 20,
                                width: 120,
                                child: snapshot.hasData
                                    ? Text('${snapshot.data.name}')
                                    : Container()),
                            items: Language.languageList()
                                .map<DropdownMenuItem<Language>>((lang) =>
                                    DropdownMenuItem(
                                      value: lang,
                                      child: Row(
                                        children: [
                                          Text(
                                            lang.flag,
                                            style:
                                                const TextStyle(fontSize: 20),
                                          ),
                                          const SizedBox(
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
                            icon: const Icon(Icons.language),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: const Divider(),
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
