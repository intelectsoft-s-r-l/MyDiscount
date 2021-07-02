import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_discount/domain/repositories/is_service_repository.dart';
import 'package:my_discount/infrastructure/core/internet_connection_service.dart';

import '../../injectable.dart';

part 'qr_event.dart';
part 'qr_state.dart';

class QrBloc extends Bloc<QrEvent, QrState> {
  QrBloc() : super(QrInitial());

  @override
  Stream<QrState> mapEventToState(
    QrEvent event,
  ) async* {
    if (event is LoadQrData) {
      final netConnection = await getIt<NetworkConnection>().isConnected;
      yield QrLoading();
      if (netConnection) {
        if (event.iteration != 3) {
          try {
            final tempId = await getIt<IsService>().getTempId();
            if (tempId.isNotEmpty) {
              yield QrLoaded(qrString: tempId, iteration: event.iteration);
            } else {
              yield QrError(tempId, event.iteration);
            }
          } catch (e) {
            yield QrError('No internet Connection', event.iteration);
          }
        } else {
          yield QrLoaded(iteration: event.iteration, qrString: '');
        }
      } else {
        yield QrError('No internet Connection', event.iteration);
      }
    }
  }
}
