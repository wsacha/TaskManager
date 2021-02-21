import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/providers/room_model.dart';
import 'package:task_manager/providers/user_model.dart';
import 'package:task_manager/services/database.dart';
import 'package:task_manager/views/tasks_screens/edittask_screen.dart';
import 'package:task_manager/widgets/task_widgets.dart';
import 'package:task_manager/widgets/widget.dart';

class Tasks extends StatelessWidget {
  final DatabaseMethods databaseMethods = new DatabaseMethods();
  final bool isTaskPoolScreen;

  Tasks(this.isTaskPoolScreen);

  @override
  Widget build(BuildContext context) {
    final roomData = Provider.of<RoomModel>(context, listen: false);
    final userData = Provider.of<UserDataModel>(context, listen: false);
    return Container(
        child: StreamBuilder(
            stream: databaseMethods.getTaskPool(
                roomData.id, isTaskPoolScreen ? "none" : userData.userName, false),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return snapshot.data.docs.length != 0
                  ? Container(
                      padding: EdgeInsets.all(12.0),
                      child: ListView.separated(
                        itemCount: snapshot.data.docs.length,
                        separatorBuilder: (_, int index) => Divider(
                          height: 12,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          final Task task = Task.fromDocumentSnapshot(
                              documentSnapshot: snapshot.data.docs[index]);
                          return Material(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xff8B4176),
                            child: ListTile(
                              onTap: () {
                                taskInfoAlertDialog(context, task);
                              },
                              onLongPress: () {
                                final act = _showTaskActions(context, task);
                                showCupertinoModalPopup(
                                    context: context, builder: (BuildContext context) => act);
                              },
                              title: Text(
                                task.title,
                                style: TextStyle(color: Colors.white, fontSize: 30),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_outlined,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Center(
                      child: Text(
                        "No tasks",
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    );
            }));
  }

  _showTaskActions(BuildContext context, Task task) {
    final userData = Provider.of<UserDataModel>(context, listen: false);
    final roomData = Provider.of<RoomModel>(context, listen: false);
    return CupertinoActionSheet(
      title: Text(
        "Choose action",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      actions: [
        CupertinoActionSheetAction(
          child: isTaskPoolScreen ? Text("Take a task") : Text("Mark task as done"),
          onPressed: () {
            if (isTaskPoolScreen) {
              databaseMethods.attachTaskToUser(task.id, userData.userName);
            } else {
              databaseMethods.markTaskAsDone(task.id);
            }
            Scaffold.of(context)
                .showSnackBar(snackBarInfo(isTaskPoolScreen ? "Task taken" : "Task completed"));
            Navigator.pop(context);
          },
          isDefaultAction: true,
        ),
        CupertinoActionSheetAction(
          child: Text("Edit task"),
          onPressed: () async {
            if (userData.userName == task.createdBy || roomData.isOwner == true) {
              print("${userData.userName} , ${task.createdBy} , ${roomData.isOwner.toString()}");
              var isAdded = await Navigator.push(
                  context, MaterialPageRoute(builder: (context) => EditTask(task)));
              if (isAdded != null) {
                Scaffold.of(context).showSnackBar(snackBarInfo("Task has been edited"));
              }
            } else {
              Scaffold.of(context)
                  .showSnackBar(snackBarInfo("You don't have permission to edit this task"));
            }
            Navigator.pop(context);
          },
          isDefaultAction: true,
        ),
        CupertinoActionSheetAction(
          child: Text("Delete task"),
          onPressed: () async {
            String message;
            var decision = await decisionAlertDialog(
                context, "Delete task", "Do you want to delete this Task?");
            if (decision == true) {
              if (userData.userName == task.createdBy || roomData.isOwner == true) {
                message = await databaseMethods.deleteTaskFromDb(task.id);
              } else {
                message = "You don't have permission to delete this task";
              }
              if (message != null) {
                Scaffold.of(context).showSnackBar(snackBarInfo(message));
              }
            }

            Navigator.pop(context);
          },
          isDestructiveAction: true,
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
