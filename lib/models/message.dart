import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String sendBy;
  String textMessage;
  DateTime messageTime;

  Message({
    this.sendBy,
    this.textMessage,
    this.messageTime,
  });

  Message.fromDocumentSnapshot({DocumentSnapshot documentSnapshot}) {
    sendBy = documentSnapshot.data()["sendBy"];
    textMessage = documentSnapshot.data()["textMessage"];
    messageTime = documentSnapshot.data()["messageTime"].toDate();
  }

  Message.fromJson(Map<String, dynamic> json) {
    sendBy = json['sendBy'];
    textMessage = json['textMessage'];
    messageTime = json['messageTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['sendBy'] = this.sendBy;
    data['textMessage'] = this.textMessage;
    data['messageTime'] = Timestamp.fromDate(this.messageTime);
    return data;
  }
}
