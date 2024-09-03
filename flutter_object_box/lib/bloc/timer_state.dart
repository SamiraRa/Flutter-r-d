part of 'timer_bloc.dart';

@immutable
class TimerState {
  final Duration playedTime;

  TimerState({required this.playedTime});

  TimerState copyWith({Duration? playedTime}) {
    return TimerState(
      playedTime: playedTime ?? this.playedTime,
    );
  }
}

final class TimerInitial extends TimerState {
  final Duration playedTime;

  TimerInitial(this.playedTime) : super(playedTime: Duration.zero);
}
