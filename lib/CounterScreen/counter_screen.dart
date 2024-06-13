import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alumni_circle_app/cubit/counter_cubit.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final counterCubit =
        BlocProvider.of<CounterCubit>(context); // Get the Cubit

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bloc - Cubit Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<CounterCubit, CounterState>(
              builder: (context, state) {
                return Text(
                  '${state.counter}',
                  style: const TextStyle(fontSize: 24.0),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Decrement button
                ElevatedButton(
                  onPressed: () => counterCubit.decrement(),
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 20.0),
                // Increment button
                ElevatedButton(
                  onPressed: () => counterCubit.increment(),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
