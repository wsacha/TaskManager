import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/providers/room_model.dart';
import 'package:task_manager/services/database.dart';

class Tasks extends StatelessWidget {
  final DatabaseMethods databaseMethods = new DatabaseMethods();

  @override
  Widget build(BuildContext context) {
    final roomData = Provider.of<RoomModel>(context, listen: false);
    return Container(
        child: StreamBuilder(
            stream: databaseMethods.getTaskPool(roomData.id, "none"),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Container(
                child: ListView(
                  padding: EdgeInsets.all(14),
                  children: snapshot.data.docs.map((DocumentSnapshot doc) {
                    final Task task = Task.fromDocumentSnapshot(documentSnapshot: doc);
                    return ListTile(
                      tileColor: Colors.lightBlue[300],
                      title: Text(
                        task.title,
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_outlined,
                        size: 30,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              );
            }));
  }
}
