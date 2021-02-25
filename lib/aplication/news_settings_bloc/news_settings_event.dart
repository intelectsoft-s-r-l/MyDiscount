part of 'news_settings_bloc.dart';

abstract class NewsSettingsEvent extends Equatable {
  const NewsSettingsEvent();

  @override
  List<Object> get props => [];
}
class DeactivateNews extends NewsSettingsEvent{}
class ActivateNews extends NewsSettingsEvent{}