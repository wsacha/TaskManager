import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/providers/room_model.dart';
import 'package:task_manager/providers/user_model.dart';
import 'package:task_manager/services/database.dart';

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
                          print("lol");
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
}
