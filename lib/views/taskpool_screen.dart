import 'package:flutter/material.dart';
import 'package:task_manager/widgets/custom_sidemenu.dart';
import 'package:task_manager/widgets/task_widgets.dart';

class TaskPool extends StatefulWidget {
  @override
  _TaskPoolState createState() => _TaskPoolState();
}

class _TaskPoolState extends State<TaskPool> {
  int navIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: taskAppBar(navIndex),
      drawer: CustomSideNav(navIndex, (int index) {
        setState(() {
          navIndex = index;
        });
      }),
      body: Builder(
        builder: (context) {
          switch (navIndex) {
            case 0:
              return Center(
                child: Text(
                  "Task Pool",
                  style: TextStyle(color: Colors.white),
                ),
              );
            case 1:
              return Center(
                child: Text(
                  "My tasks",
                  style: TextStyle(color: Colors.white),
                ),
              );
            case 2:
              return Center(
                child: Text(
                  "Team members' tasks",
                  style: TextStyle(color: Colors.white),
                ),
              );
            case 3:
              return Center(
                child: Text(
                  "Team chat",
                  style: TextStyle(color: Colors.white),
                ),
              );
            default:
              return Center(
                child: Text(
                  "My App",
                  style: TextStyle(color: Colors.white),
                ),
              );
          }
        },
      ),
    );
  }
}
