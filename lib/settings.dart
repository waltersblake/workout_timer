import 'package:flutter/material.dart';
import './workout_timer.dart';
import './settings_item.dart';

enum WorkoutItemType {cycles, sets, workoutTime, restTime}
typedef SettingsItemCallback = void Function(WorkoutItemType, int);

class Settings extends StatelessWidget{
  Settings({Key? key, required this.onSettingsUpdate, required this.data}) : super(key: key);

  final WorkoutDataCallback onSettingsUpdate;
  final WorkoutData data;
  final Map<WorkoutItemType, IconData> _settings = {WorkoutItemType.cycles: Icons.update,
  WorkoutItemType.sets: Icons.fitness_center,
  WorkoutItemType.workoutTime: Icons.schedule,
  WorkoutItemType.restTime: Icons.watch_later};
  final List<SettingsListItem> _tiles = [];

  void _itemUpdate(WorkoutItemType type, int value){
    switch(type){
      case WorkoutItemType.cycles:
        data.totalCycles = value;
        break;
      case WorkoutItemType.sets:
        data.totalSets = value;
        break;
      case WorkoutItemType.workoutTime:
        data.workout = Duration(seconds: value);
        break;
      case WorkoutItemType.restTime:
        data.rest = Duration(seconds: value);
        break;
    }
    onSettingsUpdate(data);
  }

  @override
  Widget build(BuildContext context){

    _settings.forEach((key, value) {
      var name = '';
      var initValue = 0;
      switch (key){
        case WorkoutItemType.cycles:
          name = 'Cycles';
          initValue = data.totalCycles;
          break;
        case WorkoutItemType.sets:
          name = 'Sets per Cycle';
          initValue = data.totalSets;
          break;
        case WorkoutItemType.workoutTime:
          name = 'Workout Time (seconds)';
          initValue = data.workout.inSeconds;
          break;
        case WorkoutItemType.restTime:
          name = 'Rest Time (seconds)';
          initValue = data.rest.inSeconds;
          break;
      }
      _tiles.add(SettingsListItem(name: name, icon: value, onValueChanged: _itemUpdate,
        wkType: key, initialValue: initValue,));
    });
    var _dividedTiles = ListTile.divideTiles(context: context,
        tiles: _tiles).toList();

    // update data with

    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: ListView(children: _dividedTiles,)
    );
  }
}