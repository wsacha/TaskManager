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
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['roomId'] = this.roomId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['attachedTo'] = this.attachedTo;
    data['isDone'] = this.isDone;
    data['createdBy'] = this.createdBy;
    data['expirationDate'] = Timestamp.fromDate(this.expirationDate);
    return data;
  }

  Task.fromDocumentSnapshot({DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot.id;
    roomId = documentSnapshot.data()["roomId"];
    title = documentSnapshot.data()["title"];
    description = documentSnapshot.data()["description"];
    attachedTo = documentSnapshot.data()["attachedTo"];
    isDone = documentSnapshot.data()["isDone"];
    createdBy = documentSnapshot.data()["createdBy"];
    expirationDate = documentSnapshot.data()["expirationDate"].toDate();
  }

  Task.fromQuerySnapshot({QuerySnapshot querySnapshot}) {
    id = querySnapshot.docs[0].data()["id"];
    roomId = querySnapshot.docs[0].data()["roomId"];
    title = querySnapshot.docs[0].data()["title"];
    description = querySnapshot.docs[0].data()["description"];
    attachedTo = querySnapshot.docs[0].data()["attachedTo"];
    isDone = querySnapshot.docs[0].data()["isDone"];
    createdBy = querySnapshot.docs[0].data()["createdBy"];
    expirationDate = querySnapshot.docs[0].data()["expirationDate"].toDate();
  }
}
