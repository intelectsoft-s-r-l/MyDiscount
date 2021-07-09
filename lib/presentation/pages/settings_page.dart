import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../aplication/settings/settings_bloc.dart';
import '../../infrastructure/core/localization/localizations.dart';
import '../../presentation/app/my_app.dart';

import '../widgets/custom_app_bar.dart';
import '../widgets/language_drop_down_widget.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    void _changeLanguage(Language language) async {
      final _locale =
          await AppLocalizations.of(context).setLocale(language.languageCode);
      MyApp.setLocale(context, _locale);
    }

    return CustomAppBar(
      title: AppLocalizations.of(context).translate('settings'),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            BlocConsumer<SettingsBloc, SettingsState>(
              listener: (context, state) {
                if (state is LanguageChangedState) {
                  context.read<SettingsBloc>().add(NotificationStateChanged(
                      state.settings.notificationEnabled));
                }
              },
              listenWhen: (previous, current) =>
                  previous.props.first != current.props.first,
              builder: (context, state) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(
                        AppLocalizations.of(context)
                            .translate('notificationsettings'),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      trailing: Switch(
                          value: state.settings.notificationEnabled,
                          onChanged: (newValue) {
                            context
                                .read<SettingsBloc>()
                                .add(NotificationStateChanged(newValue));
                          }),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: const Divider(),
                    ),
                    ListTile(
                      title: Text(
                        AppLocalizations.of(context).translate('news'),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      trailing: Switch(
                          value: state.settings.newsEnabled,
                          onChanged: (newValue) {
                            context
                                .read<SettingsBloc>()
                                .add(NewsStateChanged(newValue));
                          }),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: const Divider(),
                    ),
                    LanguageDropDownWidget(
                        size: size,
                        function: _changeLanguage,
                        bloc: context.read<SettingsBloc>()),
                  ],
                );
              },
            ),
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: const Divider(),
            ),
          ],
        ),
        /* ), */
      ),
    );
  }
}
