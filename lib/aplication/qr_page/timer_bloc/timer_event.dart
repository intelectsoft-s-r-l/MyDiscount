part of 'timer_bloc.dart';

abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object> get props => [];
}

class TimerStarted extends TimerEvent {
  const TimerStarted({
    required this.duration,
    required this.iteration,
  });
  final int duration;
  final int iteration;
}

class TimerReset extends TimerEvent {
  const TimerReset(this.iteration);
  final int iteration;
}

class TimerTicked extends TimerEvent {
  const TimerTicked({
    required this.duration,
    required this.iteration,
  });
  final int duration;
  final int iteration;
  @override
  List<Object> get props => [duration];
}
