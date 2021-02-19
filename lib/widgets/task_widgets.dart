import 'package:flutter/material.dart';
import 'package:task_manager/models/room.dart';
import 'package:task_manager/models/task.dart';

Widget taskAppBar(int navIndex) {
  switch (navIndex) {
    case 0:
      return AppBar(
        title: Text("Task Pool"),
      );
    case 1:
      return AppBar(
        title: Text("My tasks"),
      );
    case 2:
      return AppBar(
        title: Text("Team members' tasks"),
      );
    case 3:
      return AppBar(
        title: Text("Team chat"),
      );
    case 4:
      return AppBar(
        title: Text("About room"),
      );
    default:
      return AppBar(
        title: Text("My App"),
      );
  }
}

Text navText(String text) {
  return Text(
    text,
    style: TextStyle(color: Colors.white, fontSize: 21),
  );
}

Container aboutRoomInfo(BuildContext context, Room room) {
  return Container(
    child: Column(
      children: [
        Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Icon(
                Icons.info_outline,
                color: Colors.white,
                size: 60,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                room.roomTitle,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                room.description,
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              Divider(color: Colors.grey.shade400),
              infoListTile("ID", room.id),
              Divider(color: Colors.grey.shade400),
              infoListTile("Entry key", room.entryKey),
              Divider(color: Colors.grey.shade400),
              infoListTile("Owner", room.owner),
              Divider(color: Colors.grey.shade400),
              infoListTile("Number of members", room.participants.length.toString()),
              Divider(color: Colors.grey.shade400)
            ],
          ),
        )
      ],
    ),
  );
}

ListTile infoListTile(String title, String text) {
  return ListTile(
    dense: true,
    title: Text(
      title,
      style: TextStyle(color: Colors.white, fontSize: 20),
    ),
    subtitle: Text(text, style: TextStyle(color: Colors.white70, fontSize: 15)),
  );
}

taskInfoAlertDialog(BuildContext context, Task task) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Task Info"),
          content: ListView(
            children: [
              taskInfoListTile("Title", task.title),
              taskInfoListTile("Description", task.description),
              taskInfoListTile("Due date", task.expirationDate.toString()),
              taskInfoListTile("Status", task.isDone ? "done" : "to-do"),
              taskInfoListTile("Created by", task.createdBy)
            ],
          ),
          actions: [
            FlatButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
}

ListTile taskInfoListTile(String title, String content) {
  return ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
    dense: true,
    title: Text(
      "$title:",
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    ),
    subtitle: Text(content, style: TextStyle(fontSize: 17)),
  );
}
