part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  

  @override
  List<Object> get props => [];
}

class ActivatePush extends SettingsEvent {
  ActivatePush(this.value);
  final bool value;
}

class ActivateNews extends SettingsEvent {
  ActivateNews(this.value);
  final bool value;
}

class ChangeLocale extends SettingsEvent {
  final Locale locale;

  ChangeLocale(this.locale);
}
