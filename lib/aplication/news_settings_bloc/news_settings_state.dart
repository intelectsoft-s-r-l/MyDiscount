part of 'news_settings_bloc.dart';

abstract class NewsSettingsState extends Equatable {
  const NewsSettingsState();
  
  @override
  List<Object> get props => [];
}

class NewsSettingsActivated extends NewsSettingsState {}
class NewsSettingsDeActivated extends NewsSettingsState {}
