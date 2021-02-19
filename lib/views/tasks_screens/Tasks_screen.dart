import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/providers/room_model.dart';
import 'package:task_manager/providers/user_model.dart';
import 'package:task_manager/services/database.dart';
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
                roomData.id, isTaskPoolScreen ? "none" : userData.userName),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Container(
                padding: EdgeInsets.all(12.0),
                child: ListView.separated(
                  itemCount: snapshot.data.docs.length,
                  separatorBuilder: (_, int index) => Divider(
                    height: 12,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final Task task =
                        Task.fromDocumentSnapshot(documentSnapshot: snapshot.data.docs[index]);
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
              );
            }));
  }

  _showTaskActions(BuildContext context, Task task) {
    return CupertinoActionSheet(
      title: Text(
        "Choose action",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      actions: [
        CupertinoActionSheetAction(
          child: Text("Take a task"),
          onPressed: () {},
          isDefaultAction: true,
        ),
        CupertinoActionSheetAction(
          child: Text("Edit task"),
          onPressed: () {},
          isDefaultAction: true,
        ),
        CupertinoActionSheetAction(
          child: Text("Delete task"),
          onPressed: () async {
            await decisionAlertDialog(context, "Delete task", "Do you want to delete this Task?")
                .then((val) {
              if (val == true) {
                final userData = Provider.of<UserDataModel>(context, listen: false);
                final roomData = Provider.of<RoomModel>(context, listen: false);
                if (userData.userName == task.createdBy || roomData.isOwner == true) {
                  print(
                      "${userData.userName} , ${task.createdBy} , ${roomData.isOwner.toString()}");
                  databaseMethods.deleteTaskFromDb(task.id);
                } else {
                  Scaffold.of(context)
                      .showSnackBar(snackBarInfo("You don't have permission to delete this task"));
                }
              }
            });
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
