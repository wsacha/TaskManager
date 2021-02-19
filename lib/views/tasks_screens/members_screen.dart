import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/models/room.dart';
import 'package:task_manager/providers/room_model.dart';
import 'package:task_manager/services/database.dart';

class Members extends StatelessWidget {
  final DatabaseMethods databaseMethods = new DatabaseMethods();

  @override
  Widget build(BuildContext context) {
    final roomData = Provider.of<RoomModel>(context, listen: false);

    return Container(
      child: StreamBuilder(
        stream: databaseMethods.getRoomById(roomData.id),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final Room room = Room.fromDocumentSnapshot(documentSnapshot: snapshot.data);
          return Container(
            padding: EdgeInsets.all(8.0),
            child: ListView.separated(
                itemCount: room.participants.length,
                itemBuilder: (BuildContext context, int index) {
                  return Material(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: ListTile(
                      onTap: () {},
                      onLongPress: () {},
                      subtitle: (room.participants[index] == room.owner)
                          ? Text(" \u{2B50} Admin",
                              style: TextStyle(color: Colors.white60, fontSize: 16))
                          : Text("Member", style: TextStyle(color: Colors.white60, fontSize: 16)),
                      title: Text(
                        room.participants[index],
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, int index) => Divider(
                      color: Colors.grey.shade400,
                    )),
          );
        },
      ),
    );
  }
}
