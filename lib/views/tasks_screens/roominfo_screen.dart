import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/models/room.dart';
import 'package:task_manager/providers/room_model.dart';
import 'package:task_manager/providers/user_model.dart';
import 'package:task_manager/services/database.dart';
import 'package:task_manager/views/home.dart';
import 'package:task_manager/widgets/task_widgets.dart';
import 'package:task_manager/widgets/widget.dart';

class RoomInfo extends StatelessWidget {
  final DatabaseMethods databaseMethods = new DatabaseMethods();

  @override
  Widget build(BuildContext context) {
    final roomData = Provider.of<RoomModel>(context, listen: false);
    final userData = Provider.of<UserDataModel>(context, listen: false);

    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: databaseMethods.getRoomInfo(roomData.id),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final Room roomInfo = Room.fromQuerySnapshot(querySnapshot: snapshot.data);
                  return aboutRoomInfo(context, roomInfo);
                } else if (snapshot.connectionState == ConnectionState.none) {
                  return Text("No data");
                }
                return CircularProgressIndicator();
              },
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              color: Colors.red[500],
              child: Text(
                "Leave group",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                var message;
                if (roomData.isOwner) {
                  message = "Admin can't leave group";
                } else {
                  bool decision = await decisionAlertDialog(
                      context, "Leave group", "Are you sure you want to leave this group?");
                  if (decision == true) {
                    await databaseMethods.deleteMemberOfRoom(roomData.id, userData.userName);
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => HomeRoom()));
                  }
                }
                if (message != null) {
                  Scaffold.of(context).showSnackBar(snackBarInfo(message));
                }
              },
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
