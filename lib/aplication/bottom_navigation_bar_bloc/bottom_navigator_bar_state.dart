part of 'bottom_navigator_bar_bloc.dart';

abstract class BottomNavigatorBarState extends Equatable {
  const BottomNavigatorBarState();

  @override
  List<Object> get props => [];
}

class QrPageState extends BottomNavigatorBarState {}

class HomePageState extends BottomNavigatorBarState {}

class NewsPageState extends BottomNavigatorBarState {}
