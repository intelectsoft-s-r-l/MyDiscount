import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'news_settings_event.dart';
part 'news_settings_state.dart';

class NewsSettingsBloc extends Bloc<NewsSettingsEvent, NewsSettingsState> {
  NewsSettingsBloc() : super(NewsSettingsActivated());

  @override
  Stream<NewsSettingsState> mapEventToState(
    NewsSettingsEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
