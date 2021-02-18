import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String id;
  String roomId;
  String title;
  String description;
  String attachedTo;
  bool isDone;
  String createdBy;
  DateTime expirationDate;

  Task({
    this.id,
    this.roomId,
    this.title,
    this.description,
    this.attachedTo,
    this.isDone,
    this.createdBy,
    this.expirationDate,
  });

  Task.fromQuerySnapshot({QuerySnapshot querySnapshot}) {
    id = querySnapshot.docs[0].data()["id"];
    roomId = querySnapshot.docs[0].data()["roomId"];
    title = querySnapshot.docs[0].data()["title"];
    description = querySnapshot.docs[0].data()["description"];
    attachedTo = querySnapshot.docs[0].data()["attachedTo"];
    isDone = querySnapshot.docs[0].data()["isDone"];
    createdBy = querySnapshot.docs[0].data()["createdBy"];
    expirationDate = querySnapshot.docs[0].data()["expirationDate"];
  }
}
