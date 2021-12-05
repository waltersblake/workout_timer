import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import './workout_status.dart';
import './timer.dart';
import './settings.dart';

typedef TickerCallback = void Function();
typedef ResetCallback = void Function();
typedef WorkoutDataCallback = void Function(WorkoutData);

class WorkoutTimer extends StatefulWidget {
  const WorkoutTimer({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<WorkoutTimer> createState() => _WorkoutTimerState();
}

class _WorkoutTimerState extends State<WorkoutTimer> with SingleTickerProviderStateMixin {

  WorkoutData _workoutData = WorkoutData();
  late TimerCallbacks _timerCallbacks;

  late final Ticker _ticker;
  late Duration _setTime;
  late Duration _restTime;
  late Duration _countDown;
  final Duration _second = const Duration(seconds: 1);
  String _toggleButtonLabel = 'Start';
  var _count = 0;
  var _isSet = true;

  @override
  void initState() {
    super.initState();
    _setTime = _workoutData.workout;
    _restTime = _workoutData.rest;
    _countDown = _setTime;
    _timerCallbacks = TimerCallbacks(toggleTicker: _toggleTicker, reset: null);

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
        if(!_isSet){
          _updateSets();
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
        _timerCallbacks.reset = _resetTicker;
      });
    }
  }

  void _resetTicker() {
    if (_ticker.isActive) {
      _ticker.stop();
    }
    setState(() {
      _countDown =  _workoutData.workout;
      _toggleButtonLabel = 'Start';
      _timerCallbacks.reset = null;
      _workoutData.currentSet = 1;
      _workoutData.currentCycle = 1;
    });
  }

  void _updateSets(){
    if(_workoutData.currentSet < _workoutData.totalSets){
      setState(() {
        _workoutData.currentSet++;
      });
    } else if (_workoutData.currentSet == _workoutData.totalSets){
      _updateCycles();
    }
  }

  void _updateCycles(){
    if(_workoutData.currentCycle < _workoutData.totalCycles){
      setState(() {
        _workoutData.currentCycle++;
        _workoutData.currentSet = 1;
      });
    } else if (_workoutData.currentCycle == _workoutData.totalCycles){
      _resetTicker();
    }
  }

  void _pushSettings(){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context){
          return Settings(data: _workoutData,
            onSettingsUpdate: _updateWorkoutData,);
        }
    ,
      )
    );
  }

  void _updateWorkoutData(WorkoutData d){
        debugPrint('Update workout settings here');
        setState(() {
          _workoutData = d;
          _setTime = _workoutData.workout;
          _restTime = _workoutData.rest;
          _countDown = _setTime;
        });
  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the WorkoutTimer object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: [
          IconButton(onPressed: _pushSettings, icon: const Icon(Icons.settings))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            WorkoutStatus(data: _workoutData),
            const Spacer(),
            TimerDisplay(data: _timerCallbacks, timerLabel: _countDown.toString(),
              buttonLabel: _toggleButtonLabel,),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}

class WorkoutData{
  WorkoutData({this.totalSets = 1, this.currentSet = 1,
    this.totalCycles = 1, this.currentCycle = 1,
  this.workout = const Duration(seconds: 30), this.rest = const Duration(seconds:10)});

  int totalSets, currentSet, totalCycles, currentCycle;
  Duration workout, rest;
}
