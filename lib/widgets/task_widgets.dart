import 'package:flutter/material.dart';

Widget taskAppBar(int navIndex) {
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
    case 4:
      return AppBar(
        title: Text("About room"),
      );
    default:
      return AppBar(
        title: Text("My App"),
      );
  }
}

Text navText(String text) {
  return Text(
    text,
    style: TextStyle(color: Colors.white, fontSize: 21),
  );
}
