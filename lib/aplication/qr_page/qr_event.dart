part of 'qr_bloc.dart';

abstract class QrEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadQrData extends QrEvent {
  final int iteration;

  LoadQrData(this.iteration);
}
