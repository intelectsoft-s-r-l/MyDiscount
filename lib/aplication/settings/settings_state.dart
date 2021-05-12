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
