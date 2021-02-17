import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/room_model.dart';
import 'package:task_manager/services/database.dart';

class RoomInfo extends StatelessWidget {
  DatabaseMethods databaseMethods = new DatabaseMethods();

  @override
  Widget build(BuildContext context) {
    final roomData = Provider.of<RoomModel>(context, listen: false);

    return Container(
      child: FutureBuilder(
        future: databaseMethods.getRoomInfo(roomData.id),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder();
          } else if (snapshot.connectionState == ConnectionState.none) {
            return Text("No data");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}