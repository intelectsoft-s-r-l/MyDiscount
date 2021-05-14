part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class NotificationStateChanged extends SettingsEvent {
  final bool isActive;
  const NotificationStateChanged(this.isActive);
}

class NewsStateChanged extends SettingsEvent {
  final bool isActive;
  const NewsStateChanged(this.isActive);
}

class LangageChanged extends SettingsEvent {}
