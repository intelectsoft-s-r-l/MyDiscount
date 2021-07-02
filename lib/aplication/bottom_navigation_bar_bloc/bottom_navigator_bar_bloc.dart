import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'bottom_navigator_bar_event.dart';
part 'bottom_navigator_bar_state.dart';
@injectable
class BottomNavigatorBarBloc
    extends Bloc<BottomNavigatorBarEvent, BottomNavigatorBarState> {
  BottomNavigatorBarBloc() : super(QrPageState());

  @override
  Stream<BottomNavigatorBarState> mapEventToState(
    BottomNavigatorBarEvent event,
  ) async* {
    if (event is QrIconTapped) {
      yield QrPageState();
    }
    if (event is HomeIconTapped) {
      yield HomePageState();
    }
    if (event is NewsIconTapped) {
      yield NewsPageState();
    }
  }
}
