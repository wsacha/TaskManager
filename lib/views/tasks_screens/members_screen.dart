import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/models/room.dart';
import 'package:task_manager/providers/room_model.dart';
import 'package:task_manager/providers/user_model.dart';
import 'package:task_manager/services/database.dart';
import 'package:task_manager/widgets/widget.dart';

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
                      onLongPress: () {
                        if (roomData.isOwner == true) {
                          final act = _showMemberActions(context, room.participants[index]);
                          showCupertinoModalPopup(
                              context: context, builder: (BuildContext context) => act);
                        }
                      },
                      subtitle: (room.participants[index] == room.owner)
                          ? Text(" \u{2B50} Owner",
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

  _showMemberActions(BuildContext context, String participant) {
    final roomData = Provider.of<RoomModel>(context, listen: false);
    final userData = Provider.of<UserDataModel>(context, listen: false);

    return CupertinoActionSheet(
      title: Text(
        "Choose action",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      actions: [
        CupertinoActionSheetAction(
          child: Text("Make owner of this room"),
          onPressed: () async {
            String message;
            if (userData.userName != participant) {
              var decision = await decisionAlertDialog(
                  context, "Make owner", "Do you want to make this member an owner of this group?");
              if (decision == true) {
                await databaseMethods.changeOwnerOfRoom(roomData.id, participant);
                roomData.isOwner = false;
              }
            } else {
              message = "You are already owner of this group";
            }
            if (message != null) {
              Scaffold.of(context).showSnackBar(snackBarInfo(message));
            }
            Navigator.pop(context);
          },
        ),
        CupertinoActionSheetAction(
          isDestructiveAction: true,
          child: Text("Delete member"),
          onPressed: () async {
            String message;
            if (userData.userName != participant) {
              var decision = await decisionAlertDialog(
                  context, "Delete Member", "Do you want to delete this Task?");
              if (decision == true) {
                message = await databaseMethods.deleteMemberOfRoom(roomData.id, participant);
              }
            } else {
              message = "You can't delete yourself";
            }
            if (message != null) {
              Scaffold.of(context).showSnackBar(snackBarInfo(message));
            }
            Navigator.pop(context);
          },
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
