import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc() : super(TimerState(playedTime: Duration.zero));

  late DateTime _startTime;
  Duration _currentPlayedTime = Duration.zero;

  @override
  Stream<TimerState> mapEventToState(TimerEvent event) async* {
    if (event is PlayTimer) {
      _startTime = DateTime.now();
    } else if (event is PauseTimer || event is StopTimer) {
      _currentPlayedTime += DateTime.now().difference(_startTime);
      yield state.copyWith(playedTime: _currentPlayedTime);
    }
  }
}
