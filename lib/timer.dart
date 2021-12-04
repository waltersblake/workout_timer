import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:workout_timer/workout_timer.dart';

typedef TimerCallback = void Function();

class Timer extends StatefulWidget {
  const Timer({Key? key, required this.data}) : super(key: key);

  final TimerData data;

  @override
  State<Timer> createState() => _TimerState();
}

class _TimerState extends State<Timer> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  late Duration _setTime;
  late Duration _restTime;
  late Duration _countDown;
  final Duration _second = const Duration(seconds: 1);
  String _toggleButtonLabel = 'Start';
  TimerCallback? _reset;
  var _count = 0;
  var _isSet = true;

  @override
  void initState() {
    super.initState();
    _setTime = widget.data.workout;
    _restTime = widget.data.rest;
    _countDown = _setTime;
    _ticker = createTicker(_tick);
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _tick(Duration elapsed){
    // ticker ticks with the screen rate, 60fps.
    // since we only care about seconds, set the state once every 60 frames.
    if(_count == 60){
      _count = 0;
      // switch displayed timer between the set time and the rest time,
      // and update completed sets if setTime is finishing
      if(_countDown == Duration.zero){
        if(_isSet){
          widget.data.onSetsUpdate();
        }
        _toggleSetRest();
        return;
      }
      // count down one second
      setState(() {
        _countDown = _countDown - _second;
      });
    } else {
      _count++;
    }

  }

  void _toggleSetRest(){
    if(_isSet){
      setState(() {
        _countDown = _restTime;
      });
    } else {
      setState(() {
        _countDown = _setTime;
      });
    }
    _isSet = !_isSet;
  }

  void _toggleTicker() {
    if(_ticker.isActive){
      _ticker.stop();
      setState(() {
        _toggleButtonLabel = 'Start';
      });
    } else {
      _ticker.start();
      setState(() {
        _toggleButtonLabel = 'Pause';
        _reset = _resetTicker;
      });
    }
  }

  void _resetTicker() {
    if (_ticker.isActive) {
      _ticker.stop();
    }
    setState(() {
      _countDown = _isSet ? widget.data.workout : widget.data.rest;
      _toggleButtonLabel = 'Start';
      _reset = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        Text('$_countDown'),
        const SizedBox(width: 0,
        height: 90,),
        TimerButtons(onToggle: _toggleTicker, onReset: _reset, label: _toggleButtonLabel),
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

class TimerData {
  TimerData({required this.workout, required this.rest, required this.totalSets,
    required this.totalCycles, required this.onCyclesUpdate, required this.onSetsUpdate});
  Duration workout;
  Duration rest;
  int totalSets;
  int totalCycles;
  SetsCallback onSetsUpdate;
  CyclesCallback onCyclesUpdate;
}
