import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'qrimage_event.dart';
part 'qrimage_state.dart';

class QrImageBloc extends Bloc<QrImageEvent, QrImageState> {
  QrImageBloc() : super(QrImageInitial());

  @override
  Stream<QrImageState> mapEventToState(
    QrImageEvent event,
  ) async* {

  }
}
