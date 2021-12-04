import 'package:flutter/material.dart';

// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

i

// This entire list item is a PopupMenuButton. Tapping anywhere shows
// a menu whose current value is highlighted and aligned over the
// list item's center line.
class _SimpleMenuDemo extends StatefulWidget {
  const _SimpleMenuDemo({Key key, this.showInSnackBar}) : super(key: key);

  final void Function(String value) showInSnackBar;

  @override
  _SimpleMenuDemoState createState() => _SimpleMenuDemoState();
}

class _SimpleMenuDemoState extends State<_SimpleMenuDemo> {
  SimpleValue _simpleValue;

  void showAndSetMenuSelection(BuildContext context, SimpleValue value) {
    setState(() {
      _simpleValue = value;
    });
    widget.showInSnackBar(
      GalleryLocalizations.of(context)
          .demoMenuSelected(simpleValueToString(context, value)),
    );
  }

  String simpleValueToString(BuildContext context, SimpleValue value) => {
    SimpleValue.one: GalleryLocalizations.of(context).demoMenuItemValueOne,
    SimpleValue.two: GalleryLocalizations.of(context).demoMenuItemValueTwo,
    SimpleValue.three:
    GalleryLocalizations.of(context).demoMenuItemValueThree,
  }[value];

  @override
  void initState() {
    super.initState();
    _simpleValue = SimpleValue.two;
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SimpleValue>(
      padding: EdgeInsets.zero,
      initialValue: _simpleValue,
      onSelected: (value) => showAndSetMenuSelection(context, value),
      itemBuilder: (context) => <PopupMenuItem<SimpleValue>>[
        PopupMenuItem<SimpleValue>(
          value: SimpleValue.one,
          child: Text(simpleValueToString(
            context,
            SimpleValue.one,
          )),
        ),
        PopupMenuItem<SimpleValue>(
          value: SimpleValue.two,
          child: Text(simpleValueToString(
            context,
            SimpleValue.two,
          )),
        ),
        PopupMenuItem<SimpleValue>(
          value: SimpleValue.three,
          child: Text(simpleValueToString(
            context,
            SimpleValue.three,
          )),
        ),
      ],
      child: ListTile(
        title: Text(
            GalleryLocalizations.of(context).demoMenuAnItemWithASimpleMenu),
        subtitle: Text(simpleValueToString(context, _simpleValue)),
      ),
    );
  }
}

