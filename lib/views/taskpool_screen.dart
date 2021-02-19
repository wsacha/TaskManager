import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/room_model.dart';
import 'package:task_manager/views/home.dart';
import 'package:task_manager/views/tasks_screens/Tasks_screen.dart';
import 'package:task_manager/views/tasks_screens/addtask_screen.dart';
import 'package:task_manager/views/tasks_screens/members_screen.dart';
import 'package:task_manager/views/tasks_screens/roominfo_screen.dart';
import 'package:task_manager/widgets/custom_sidemenu.dart';
import 'package:task_manager/widgets/task_widgets.dart';
import 'package:task_manager/widgets/widget.dart';

class TaskPool extends StatefulWidget {
  @override
  _TaskPoolState createState() => _TaskPoolState();
}

class _TaskPoolState extends State<TaskPool> {
  int navIndex = 0;
  @override
  Widget build(BuildContext context) {
    final roomData = Provider.of<RoomModel>(context, listen: false);

    return WillPopScope(
      onWillPop: () => _moveToRoomsScreen(context),
      child: Scaffold(
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
                return Tasks(true);
              case 1:
                return Tasks(false);
              case 2:
                return Members();
              case 3:
                return Center(
                  child: Text(
                    "Team chat",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              case 4:
                return RoomInfo();

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
        floatingActionButton: Builder(
          builder: (context) {
            switch (navIndex) {
              case 0:
                {
                  return FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () async {
                      print("task pool");
                      var isAdded = await Navigator.push(
                          context, MaterialPageRoute(builder: (context) => AddTask(true)));
                      if (isAdded != null) {
                        Scaffold.of(context).showSnackBar(snackBarInfo("Task has been edited"));
                      }
                    },
                  );
                }
              case 1:
                {
                  return FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () async {
                      print("my tasks");
                      var isAdded = await Navigator.push(
                          context, MaterialPageRoute(builder: (context) => AddTask(false)));
                      if (isAdded != null) {
                        Scaffold.of(context).showSnackBar(snackBarInfo("Task has been edited"));
                      }
                    },
                  );
                }
              case 2:
                {
                  return roomData.isOwner
                      ? FloatingActionButton(
                          child: Icon(Icons.add),
                          onPressed: () {
                            print("Add user");
                          },
                        )
                      : Container(
                          height: 0,
                          width: 0,
                        );
                }
              default:
                return Container(
                  height: 0,
                  width: 0,
                );
            }
          },
        ),
      ),
    );
  }

  Future<bool> _moveToRoomsScreen(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeRoom()));
    return Future.value(false);
  }
}
