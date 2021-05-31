part of 'timer_bloc.dart';

abstract class TimerState extends Equatable {
  const TimerState(this.duration, this.iteration);
  final int duration;
  final int iteration;
  @override
  List<Object> get props => [duration, iteration];
}

class TimerInitial extends TimerState {
  TimerInitial({
    required int duration,
    required int iteration,
  }) : super(duration, iteration);
}

class TimerRunInProgress extends TimerState {
  TimerRunInProgress({
    required int duration,
    required int iteration,
  }) : super(duration, iteration);
}

class TimerRunComplete extends TimerState {
  const TimerRunComplete({required int iteration}) : super(0, iteration);
}
