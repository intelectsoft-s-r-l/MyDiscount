import 'package:flutter/material.dart';

import '../../aplication/settings/settings_bloc.dart';
import '../../core/localization/localizations.dart';

class LanguageDropDownWidget extends StatelessWidget {
  const LanguageDropDownWidget({
    Key? key,
    required this.size,
    required this.function,
    required this.bloc,
  }) : super(key: key);
  final Function function;
  final Size size;
  final SettingsBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      padding: const EdgeInsets.only(right: 10),
      child: ListTile(
        title: Text(
          AppLocalizations.of(context)!.translate('lang')!,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        trailing: FutureBuilder<Language>(
          future: AppLocalizations.of(context)!.getLanguage(),
          builder: (context, snapshot) => DropdownButton<Language>(
            underline: Container(),
            hint: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 5),
                height: 20,
                width: 120,
                child: snapshot.hasData
                    ? Text('${snapshot.data!.name}')
                    : Container()),
            items: Language.languageList()
                .map<DropdownMenuItem<Language>>((lang) => DropdownMenuItem(
                      value: lang,
                      child: Row(
                        children: [
                          Text(
                            lang.flag,
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(lang.name),
                        ],
                      ),
                    ))
                .toList(),
            onChanged: (Language? language) {
              function(language!);
              bloc.add(LangageChanged());
            },
            icon: const Icon(Icons.language),
          ),
        ),
      ),
    );
  }
}
