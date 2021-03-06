import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'qr_page_event.dart';
part 'qr_page_state.dart';

class QrPageBloc extends Bloc<QrPageEvent, QrPageState> {
  QrPageBloc() : super(QrPageInitial());

  

  @override
  Stream<QrPageState> mapEventToState(
    QrPageEvent event,
  ) async* {}
}

class Ticker {
  Stream<int> tick({int ticks}) {
    return Stream.periodic(Duration(seconds: 1), (x) => ticks - x - 1).take(ticks);
  }
}
