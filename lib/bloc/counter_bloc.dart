import 'package:bloc/bloc.dart';
import 'counter_event.dart';
import 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterState(counterValue: 0)) {
    // 接收Event為Increment的Event
    on<Increment>((event, emit) {
      // 回到觸發State的流程
      emit(CounterState(counterValue: state.counterValue + 1));
    });
    // 接收Event為Decrement的Event
    on<Decrement>((event, emit) {
      // 回到觸發State的流程
      emit(CounterState(counterValue: state.counterValue - 1));
    });
  }
}