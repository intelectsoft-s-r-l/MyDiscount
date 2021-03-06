part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  const SettingsState._({
    @required this.isPushActivated,
    @required this.isNewsActivated,
    @required this.currentLocale,
  });
  final bool isPushActivated;
  final bool isNewsActivated;
  final Locale currentLocale;

  factory SettingsState.initial() {
    return SettingsState._(
        isPushActivated: false,
        isNewsActivated: false,
        currentLocale: Locale('ru'));
  }

  SettingsState copyWith({
    bool isPushActivated,
    bool isNewsActivated,
    Locale currentLocale,
  }) {
    return SettingsState._(
        isPushActivated: isPushActivated ?? this.isPushActivated,
        isNewsActivated: isNewsActivated ?? this.isNewsActivated,
        currentLocale: currentLocale ?? this.currentLocale);
  }

  @override
  List<Object> get props => [isPushActivated, isNewsActivated, currentLocale];
}
