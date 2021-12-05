import 'package:flutter/material.dart';
import 'package:workout_timer/workout_timer.dart';

typedef TimerCallback = void Function();

class TimerDisplay extends StatelessWidget {
  const TimerDisplay(
      {Key? key, required this.data, required this.timerLabel, required this.buttonLabel, required this.isSet})
      : super(key: key);

  final TimerCallbacks data;
  final Duration timerLabel;
  final String buttonLabel;
  final bool isSet;
  final _workColor = 0xFF504CAF;
  final _restColor = 0xFFAF504C;
  final _workLabel = 'Work!';
  final _restLabel = 'Rest!';

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    //String hours = twoDigits(d.inHours);
    String minutes = twoDigits(d.inMinutes.remainder(60));
    String seconds = twoDigits(d.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 80),
        child: Column(
          children: [
            Text(
              _formatDuration(timerLabel),
              style: const TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
            ),
            if(isSet)
              Text(_workLabel, style: TextStyle( fontSize: 25, color: Color(_workColor)))
            else
              Text(_restLabel, style: TextStyle(fontSize: 25, color: Color(_restColor))),
            const SizedBox(
              width: 0,
              height: 140,
            ),
            TimerButtons(onToggle: data.toggleTicker, onReset: data.reset, label: buttonLabel),
          ],
        ));
  }
}

class TimerButtons extends StatelessWidget {
  const TimerButtons({
    Key? key,
    required this.onToggle,
    required this.onReset,
    required this.label,
  }) : super(key: key);
  final TimerCallback onToggle;
  // Reset callback needs to be nullable to disable button
  final TimerCallback? onReset;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: onReset,
          child: const Text('Reset'),
        ),
        ElevatedButton(onPressed: onToggle, child: Text(label))
      ],
    );
  }
}

class TimerCallbacks {
  TimerCallbacks({required this.toggleTicker, required this.reset});
  TickerCallback toggleTicker;
  ResetCallback? reset;
}
