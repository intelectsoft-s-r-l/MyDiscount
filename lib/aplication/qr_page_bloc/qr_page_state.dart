part of 'qr_page_bloc.dart';

abstract class QrPageState extends Equatable {
  const QrPageState(this.tempId, this.progress);
  final String tempId;
  final double progress;
  @override
  List<Object> get props => [];
}

class QrPageInitial extends QrPageState {
  QrPageInitial() : super('', 0);
}

class QrPageLoading extends QrPageState {
  QrPageLoading() : super('', 0.0);
}

class QrPageLoaded extends QrPageState {
  QrPageLoaded(String tempId, double progress) : super(tempId, progress);
  
}
