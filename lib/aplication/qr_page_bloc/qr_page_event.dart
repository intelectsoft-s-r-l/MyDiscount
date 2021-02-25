part of 'qr_page_bloc.dart';

abstract class QrPageEvent extends Equatable {
  const QrPageEvent(this.iteration);
  final int iteration;

  @override
  List<Object> get props => [iteration];
}

class RequestTempId extends QrPageEvent {
  RequestTempId(int iteration) : super(iteration);
}

class StartTimer extends QrPageEvent {
  StartTimer(int iteration) : super(iteration);
}
class OutIteration extends QrPageEvent{
  OutIteration(int iteration) : super(iteration);
}