part of 'timer_bloc.dart';

@immutable
sealed class TimerEvent {}

class PlayTimer extends TimerEvent {}

class PauseTimer extends TimerEvent {}

class UpdateTimer extends TimerEvent {}

class StopTimer extends TimerEvent {}
