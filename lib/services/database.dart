import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_manager/models/room.dart';

class DatabaseMethods {
  //USER
  getUserByUserEmail(String userEmail) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: userEmail)
        .get();
  }

  getUserByUserName(String userName) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: userName)
        .get();
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap).catchError((e) {
      print(e.toString());
    });
  }

  //ROOMS
  getListOfRooms(userName) {
    return FirebaseFirestore.instance
        .collection("rooms")
        .where("participants", arrayContains: userName)
        .snapshots();
  }

  addRoomToDb(Room room) {
    return FirebaseFirestore.instance.collection("rooms").add(room.toJson());
  }

  deleteRoomFromDb(String id) {
    return FirebaseFirestore.instance
        .collection("rooms")
        .where("id", isEqualTo: id)
        .get()
        .then((result) {
      result.docs[0].reference.delete();
    }).catchError((error, stackTrace) {
      print(error);
    });
  }

  Future<String> addUserToRoom(String userName, String id, String entryKey) {
    return FirebaseFirestore.instance
        .collection("rooms")
        .where("id", isEqualTo: id)
        .where("entryKey", isEqualTo: entryKey)
        .limit(1)
        .get()
        .then((query) {
      final doc = query.docs[0];
      List<dynamic> participants = doc.data()["participants"];
      if (!participants.contains(userName)) {
        participants.add(userName);
        doc.reference.update({'participants': participants});
        return "User has joined to room";
      }
      return "User Already in room";
    }).catchError((error, stackTrace) {
      return "Invalid data";
    });
  }

  //TASKS
}
