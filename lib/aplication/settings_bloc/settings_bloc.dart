import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../core/localization/localizations.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsState.initial());

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    if (event is ActivatePush) {
      yield state.copyWith(isPushActivated: event.value);
    }
    if (event is ActivateNews) {
      yield state.copyWith(isNewsActivated: event.value);
    }
    if (event is ChangeLocale) {
      AppLocalizations(state.currentLocale)
          .setLocale(event.locale.languageCode);
      yield state.copyWith(currentLocale: event.locale);
    }
  }
}
