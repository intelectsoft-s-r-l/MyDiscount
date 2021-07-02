import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'ticker.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc(this.ticker)
      : super(TimerInitial(duration: 10, iteration: 0));
  final Ticker ticker;

  StreamSubscription<int>? _tickerSubscription;

  @override
  Stream<TimerState> mapEventToState(
    TimerEvent event,
  ) async* {
    if (event is TimerStarted) {
      yield TimerRunInProgress(
          duration: event.duration, iteration: event.iteration);
      await _tickerSubscription?.cancel();
      
      _tickerSubscription =
          ticker.tick(ticks: event.duration).listen((duration) {
        add(TimerTicked(duration: duration, iteration: event.iteration));
      });
    }
    if (event is TimerTicked) {
      yield event.duration > 0
          ? TimerRunInProgress(
              duration: event.duration, iteration: event.iteration)
          : TimerRunComplete(iteration: event.iteration);
    }
  }
}
