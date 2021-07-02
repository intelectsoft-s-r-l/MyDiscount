part of 'qr_bloc.dart';

abstract class QrState extends Equatable {
  @override
  List<Object?> get props => [];
}

class QrInitial extends QrState {}

class QrLoading extends QrState {}

class QrLoaded extends QrState {
  QrLoaded( {required this.iteration,required this.qrString});
  final String qrString;
  final int iteration;
}

class QrError extends QrState {
  QrError(this.qrString,this.iteration);
  final String qrString;
   final int iteration;
}
