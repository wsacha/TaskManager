import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/models/message.dart';
import 'package:task_manager/providers/room_model.dart';
import 'package:task_manager/providers/user_model.dart';
import 'package:task_manager/services/database.dart';
import 'package:task_manager/widgets/message_widgets.dart';
import 'package:task_manager/widgets/widget.dart';

class Chat extends StatefulWidget {
  Chat({Key key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageTextEditingController = new TextEditingController();

  _addMessage(String roomId, String sendBy) async {
    if (messageTextEditingController.text != "") {
      Message message = new Message(
          sendBy: sendBy,
          textMessage: messageTextEditingController.text,
          messageTime: DateTime.now());
      await databaseMethods.addMessageToDb(roomId, message);
      messageTextEditingController.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final roomData = Provider.of<RoomModel>(context, listen: false);
    final userData = Provider.of<UserDataModel>(context, listen: false);
    return Container(
      child: Stack(
        children: [
          StreamBuilder(
            stream: databaseMethods.getChatRoomMessages(roomData.id),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return (snapshot.data.docs.length != 0)
                  ? ListView.builder(
                      padding: EdgeInsets.only(bottom: 70, top: 15),
                      reverse: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        Message ms = Message.fromDocumentSnapshot(
                            documentSnapshot: snapshot.data.docs[index]);
                        return chatMessageTile(ms, ms.sendBy == userData.userName);
                      },
                    )
                  : Center(
                      child: Text(
                        "No messages",
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    );
            },
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Theme.of(context).primaryColor.withOpacity(0.2),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageTextEditingController,
                      style: simpleTextStyle(),
                      decoration: textFieldInputDecoration("Message"),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                    onPressed: () => _addMessage(roomData.id, userData.userName),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
