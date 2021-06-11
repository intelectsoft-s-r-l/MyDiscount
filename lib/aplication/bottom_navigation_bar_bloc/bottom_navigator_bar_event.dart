part of 'bottom_navigator_bar_bloc.dart';

abstract class BottomNavigatorBarEvent extends Equatable {
  const BottomNavigatorBarEvent();

  @override
  List<Object> get props => [];
}
class QrIconTapped extends BottomNavigatorBarEvent{}
class HomeIconTapped extends BottomNavigatorBarEvent{}
class NewsIconTapped extends BottomNavigatorBarEvent{}