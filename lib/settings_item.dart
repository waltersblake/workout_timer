import 'package:flutter/material.dart';
import './settings.dart';

class SettingsListItem extends StatefulWidget {
  const SettingsListItem({Key? key,required this.name, required this.icon,
  required this.onValueChanged, required this.wkType, required this.initialValue}) : super(key: key);

  final String name;
  final IconData icon;
  final SettingsItemCallback onValueChanged;
  final WorkoutItemType wkType;
  final int initialValue;

  @override
  State<SettingsListItem> createState() => _SettingsListItemState();
}

class _SettingsListItemState extends State<SettingsListItem> {
  late int _value;
  final List<PopupMenuItem<int>> _itemList = [];

  void setSelectedValue(BuildContext context, int value) {
    setState(() {
      _value = value;
      widget.onValueChanged(widget.wkType, value);
    });
  }

  int? get value {
    return _value;
  }

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
    for(var i = 1; i < 60; i++){
      _itemList.add(PopupMenuItem<int>(value: i,
          child: Text(i.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      padding: EdgeInsets.zero,
      initialValue: _value,
      onSelected: (value) => setSelectedValue(context, value),
      itemBuilder: (context) => _itemList,
      child: ListTile(
        leading: Icon(widget.icon),
        title: Text(widget.name),
        subtitle: Text(_value.toString()),
      ),
    );
  }
}

