import 'package:flutter/material.dart';
import './workout_timer.dart';

class WorkoutStatus extends StatelessWidget {
  const WorkoutStatus({Key? key, required this.data}) : super(key: key);

  final WorkoutData data;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [SetsCounter(totalSets: data.totalSets, currentSet: data.currentSet),
      CyclesCounter(totalCycles: data.totalCycles, currentCycle: data.currentCycle)],
    );
  }
}

class SetsCounter extends StatelessWidget {
  const SetsCounter({Key? key, required this.totalSets, required this.currentSet}) : super(key: key);

  final int totalSets, currentSet;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(16),
        child: Column(children: [
          Text('$currentSet of $totalSets',
          style: const TextStyle(fontSize: 20)),
          const Text('Sets',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
        ])
    );

  }
}

class CyclesCounter extends StatelessWidget {
  const CyclesCounter({Key? key, required this.totalCycles, required this.currentCycle}) : super(key: key);

  final int totalCycles, currentCycle;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(16),
    child: Column(children: [
      Text('$currentCycle of $totalCycles', style: const TextStyle(fontSize: 20)),
      const Text('Cycles', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
    ]));
  }
}


