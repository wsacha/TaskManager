import 'package:flutter/material.dart';
import 'package:task_manager/widgets/task_widgets.dart';

class TaskPool extends StatefulWidget {
  TaskPool({Key key}) : super(key: key);

  @override
  _TaskPoolState createState() => _TaskPoolState();
}

class _TaskPoolState extends State<TaskPool> {
  int navIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: todoAppBar(navIndex),
    );
  }
}
