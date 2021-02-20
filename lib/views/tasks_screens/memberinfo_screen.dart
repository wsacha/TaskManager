import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/providers/room_model.dart';
import 'package:task_manager/services/database.dart';
import 'package:task_manager/widgets/task_widgets.dart';

class MemberInfo extends StatelessWidget {
  MemberInfo(this.memberName);

  final String memberName;
  final DatabaseMethods databaseMethods = new DatabaseMethods();

  @override
  Widget build(BuildContext context) {
    final roomData = Provider.of<RoomModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text("Member info")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 40,
                  ),
                  Text(
                    memberName,
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Divider(color: Colors.grey.shade400),
                  Text(
                    "Tasks",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  Divider(color: Colors.grey.shade400),
                ],
              ),
            ),
            Container(
              height: 30,
              alignment: Alignment.center,
              color: Theme.of(context).primaryColor,
              child: Text(
                "In progress:",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
            Divider(color: Colors.grey.shade400),
            StreamBuilder(
                stream: databaseMethods.getTaskPool(roomData.id, memberName, false),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Column(
                    children: snapshot.data.docs.map((e) {
                      final Task task = Task.fromDocumentSnapshot(documentSnapshot: e);
                      return Material(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: Container(
                          child: Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  taskInfoAlertDialog(context, task);
                                },
                                title: Text(
                                  task.title,
                                  style: TextStyle(color: Colors.white, fontSize: 18),
                                ),
                              ),
                              Divider(color: Colors.grey.shade400),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }),
            Container(
              height: 30,
              color: Theme.of(context).primaryColor,
              alignment: Alignment.center,
              child: Text(
                "Task done:",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
            Divider(color: Colors.grey.shade400),
            StreamBuilder(
                stream: databaseMethods.getTaskPool(roomData.id, memberName, true),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Column(
                    children: snapshot.data.docs.map((e) {
                      final Task task = Task.fromDocumentSnapshot(documentSnapshot: e);
                      return Material(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: Container(
                          child: Container(
                            child: Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                    taskInfoAlertDialog(context, task);
                                  },
                                  title: Text(
                                    task.title,
                                    style: TextStyle(color: Colors.white, fontSize: 18),
                                  ),
                                ),
                                Divider(color: Colors.grey.shade400),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
