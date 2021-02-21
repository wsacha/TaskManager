import 'package:flutter/material.dart';
import 'package:task_manager/models/message.dart';

Widget chatMessageTile(Message message, bool sendByMe) {
  return Row(
    mainAxisAlignment: sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
            color: sendByMe ? Color(0xff145C9E) : Colors.blueGrey,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                bottomRight: sendByMe ? Radius.circular(0) : Radius.circular(24),
                topRight: Radius.circular(24),
                bottomLeft: sendByMe ? Radius.circular(24) : Radius.circular(0))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message.sendBy,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text(
              message.textMessage,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    ],
  );
}
