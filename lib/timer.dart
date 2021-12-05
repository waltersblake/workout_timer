import 'package:flutter/material.dart';
import 'package:workout_timer/workout_timer.dart';

typedef TimerCallback = void Function();

class TimerDisplay extends StatelessWidget {
  const TimerDisplay({Key? key, required this.data, required this.timerLabel,
    required this.buttonLabel}) : super(key: key);

  final TimerCallbacks data;
  final Duration timerLabel;
  final String buttonLabel;

  String _formatDuration(Duration d){
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    //String hours = twoDigits(d.inHours);
    String minutes = twoDigits(d.inMinutes.remainder(60));
    String seconds = twoDigits(d.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 16,
    vertical: 80),
        child: Column(
          children: [
            Text(_formatDuration(timerLabel), style: const TextStyle(
              fontSize: 70, fontWeight: FontWeight.bold
            ),),
            const SizedBox(width: 0,
              height: 165,),
            TimerButtons(onToggle: data.toggleTicker, onReset: data.reset, label: buttonLabel),
          ],
        ));
  }
}

class TimerButtons extends StatelessWidget {
  const TimerButtons({Key? key, required this.onToggle,
    required this.onReset, required this.label,}) : super
      (key: key);
  final TimerCallback onToggle;
  final TimerCallback? onReset;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(onPressed: onReset, child: const Text('Reset'),),
        ElevatedButton(onPressed: onToggle, child:  Text(label))
      ],
    );
  }
}

class TimerCallbacks {
  TimerCallbacks({required this.toggleTicker, required this.reset});
  TickerCallback toggleTicker;
  ResetCallback? reset;

}
