import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  String id;
  String roomTitle;
  String description;
  String entryKey;
  String owner;
  List<String> participants;

  Room({
    this.id,
    this.roomTitle,
    this.description,
    this.entryKey,
    this.owner,
    this.participants,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['roomTitle'] = this.roomTitle;
    data['description'] = this.description;
    data['entryKey'] = this.entryKey;
    data['owner'] = this.owner;
    if (this.participants != null) {
      data['participants'] = this.participants.map((v) => v).toList();
    } else {
      data['participants'] = [];
    }
    return data;
  }

  Room.fromDocumentSnapshot({DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot.id;
    roomTitle = documentSnapshot.data()["roomTitle"];
    description = documentSnapshot.data()["description"];
    entryKey = documentSnapshot.data()["entryKey"];
    owner = documentSnapshot.data()["owner"];
    if (documentSnapshot.data()['participants'] != null) {
      participants = List<String>.from(
        documentSnapshot.data()['participants'].map(
              (e) => (e),
            ),
      );
    }
  }
  Room.fromQuerySnapshot({QuerySnapshot querySnapshot}) {
    id = querySnapshot.docs[0].data()["id"];
    roomTitle = querySnapshot.docs[0].data()["roomTitle"];
    description = querySnapshot.docs[0].data()["description"];
    entryKey = querySnapshot.docs[0].data()["entryKey"];
    owner = querySnapshot.docs[0].data()["owner"];
    if (querySnapshot.docs[0].data()["id"] != null) {
      participants = List<String>.from(querySnapshot.docs[0].data()["participants"].map(
            (e) => (e),
          ));
    }
  }
}
