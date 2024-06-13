part of 'counter_cubit.dart';

@immutable
class CounterState { 
  final int counter;
  final String status;
  final Color color;
  const CounterState({required this.counter, required this.status, required this.color});
}

final class CounterInitialState extends CounterState {
  const CounterInitialState() : super(counter: 0, status: "genap", color: Colors.blue);
}
