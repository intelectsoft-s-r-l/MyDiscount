import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../domain/settings/settings.dart';
import '../../infrastructure/core/fcm_service.dart';
import '../../infrastructure/settings/settings_Impl.dart';

part 'settings_event.dart';
part 'settings_state.dart';

@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final AppSettings _settings;
  final FirebaseCloudMessageService _firebaseCloudMessageService;
  SettingsBloc(this._settings, this._firebaseCloudMessageService)
      : super(SettingsInitial(_settings.getSettings()));

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    if (event is NotificationStateChanged) {
      final settings =
          _settings.getSettings().copyWith(notificationEnabled: event.isActive);

      _settings.setSettings(settings);
      yield SettingsChanged(settings);

      await _firebaseCloudMessageService.getfcmToken();
    }
    if (event is NewsStateChanged) {
      final settings =
          _settings.getSettings().copyWith(newsEnabled: event.isActive);
      _settings.setSettings(settings);
      yield SettingsChanged(settings);
    }
    if (event is LangageChanged) {
      yield LanguageChangedState(_settings.getSettings());
    }
  }
}
