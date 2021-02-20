import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/providers/room_model.dart';
import 'package:task_manager/services/database.dart';
import 'package:task_manager/widgets/task_widgets.dart';

class FinishedTasks extends StatelessWidget {
  final DatabaseMethods databaseMethods = new DatabaseMethods();

  @override
  Widget build(BuildContext context) {
    final roomData = Provider.of<RoomModel>(context, listen: false);

    return Container(
      child: StreamBuilder(
        stream: databaseMethods.getDoneTaskPool(roomData.id),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text("Empty history"),
            );
          }
          return Container(
            padding: EdgeInsets.all(12.0),
            child: ListView.separated(
              itemCount: snapshot.data.docs.length,
              separatorBuilder: (_, int index) => Divider(color: Colors.grey.shade400),
              itemBuilder: (BuildContext context, int index) {
                final Task task =
                    Task.fromDocumentSnapshot(documentSnapshot: snapshot.data.docs[index]);
                return Material(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Container(
                    child: ListTile(
                      onTap: () {
                        taskInfoAlertDialog(context, task);
                      },
                      title: Text(
                        task.title,
                        style: TextStyle(color: Colors.white, fontSize: 23),
                      ),
                      subtitle: Text(
                        "Finished by: ${task.attachedTo}",
                        style: TextStyle(color: Colors.white60, fontSize: 18),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
