import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/room_model.dart';
import 'package:task_manager/services/database.dart';
import 'package:task_manager/views/home.dart';
import 'package:task_manager/views/tasks_screens/finishedtasks_screen.dart';
import 'package:task_manager/views/tasks_screens/tasks_screen.dart';
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
  DatabaseMethods databaseMethods = new DatabaseMethods();
  int navIndex = 0;
  @override
  Widget build(BuildContext context) {
    final roomData = Provider.of<RoomModel>(context, listen: true);

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
                return FinishedTasks();
              case 3:
                return Members();
              case 4:
                return Center(
                  child: Text(
                    "Team chat",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              case 5:
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
                        Scaffold.of(context).showSnackBar(snackBarInfo("Task has been added"));
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
                        Scaffold.of(context).showSnackBar(snackBarInfo("Task has been added"));
                      }
                    },
                  );
                }
              case 2:
                {
                  return roomData.isOwner
                      ? FloatingActionButton(
                          child: Icon(Icons.delete),
                          onPressed: () async {
                            String message;
                            var decision = await decisionAlertDialog(context, "Clean up history",
                                "Do you want to delete finished tasks?");
                            if (decision == true) {
                              message =
                                  await databaseMethods.deleteAllFinishedTasksFromDb(roomData.id);
                            }
                            if (message != null) {
                              Scaffold.of(context).showSnackBar(snackBarInfo(message));
                            }
                          },
                        )
                      : Container(
                          height: 0,
                          width: 0,
                        );
                }
              case 3:
                {
                  return roomData.isOwner
                      ? FloatingActionButton(
                          child: Icon(Icons.person_add),
                          onPressed: () async {
                            String message;
                            String enteredName = await _addUserAlertDialog(context);
                            if (enteredName != null) {
                              QuerySnapshot checkExistingData =
                                  await databaseMethods.getUserByUserName(enteredName);
                              if (checkExistingData.docs.isNotEmpty) {
                                message = await databaseMethods.addUserByAdminToRoom(
                                    roomData.id, enteredName);
                              } else {
                                message = "User does not exist";
                              }
                            }
                            if (message != null) {
                              Scaffold.of(context).showSnackBar(snackBarInfo(message));
                            }
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

  Future<String> _addUserAlertDialog(BuildContext context) async {
    final alertKey = GlobalKey<FormState>();
    TextEditingController userNameTextEditingController = new TextEditingController();
    return await showDialog(
      context: context,
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: AlertDialog(
                title: Text("Add user"),
                content: Form(
                  key: alertKey,
                  child: TextFormField(
                    validator: (val) {
                      return val.isEmpty ? "Enter user name" : null;
                    },
                    controller: userNameTextEditingController,
                    decoration: alertTextFieldInputDecoration("User name"),
                  ),
                ),
                actions: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FlatButton(
                        child: Text("Cancel"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      FlatButton(
                        child: Text("Submit"),
                        onPressed: () {
                          if (alertKey.currentState.validate()) {
                            Navigator.pop(context, userNameTextEditingController.text);
                          }
                        },
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
