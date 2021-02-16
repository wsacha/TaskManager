import 'package:flutter/material.dart';

Widget todoAppBar(int navIndex) {
  switch (navIndex) {
    case 0:
      return AppBar(
        title: Text("Task Pool"),
      );
    case 1:
      return AppBar(
        title: Text("My tasks"),
      );
    case 2:
      return AppBar(
        title: Text("Team members' tasks"),
      );
    case 3:
      return AppBar(
        title: Text("Team chat"),
      );
    default:
      return AppBar(
        title: Text("My App"),
      );
  }
}
