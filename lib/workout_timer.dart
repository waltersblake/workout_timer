import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import './workout_status.dart';
import './timer.dart';

typedef TickerCallback = void Function();
typedef ResetCallback = void Function();

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

  final WorkoutData _workoutData = WorkoutData(totalCycles: 3, totalSets: 3, workout: Duration(seconds: 30),
  rest: Duration(seconds: 10));
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
        if(_isSet){
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
      _countDown = _isSet ? _workoutData.workout : _workoutData.rest;
      _toggleButtonLabel = 'Start';
      _timerCallbacks.reset = null;
    });
  }

  void _updateSets(){
    if(_workoutData.currentSet < _workoutData.totalSets){
      setState(() {
        _workoutData.currentSet++;
      });
    }
  }

  void _updateCycles(){
    if(_workoutData.currentCycle < _workoutData.totalCycles){
      setState(() {
        _workoutData.currentCycle++;
      });
    }
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
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class WorkoutData{
  WorkoutData({this.totalSets = 0, this.currentSet = 0,
    this.totalCycles = 0, this.currentCycle = 0,
  required this.workout, required this.rest});

  int totalSets, currentSet, totalCycles, currentCycle;
  Duration workout, rest;
}
