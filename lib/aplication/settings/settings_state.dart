part of 'settings_bloc.dart';

abstract class SettingsState extends Equatable {
  final Settings settings;
  const SettingsState(this.settings);

  @override
  List<Object> get props => [settings];
}

class SettingsInitial extends SettingsState {
  SettingsInitial(Settings settings) : super(settings);
}

class SettingsChanged extends SettingsState {
  SettingsChanged(Settings settings) : super(settings);
}

class LanguageChangedState extends SettingsState {
  LanguageChangedState(Settings settings) : super(settings);
}
