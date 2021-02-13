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
        .collection('rooms')
        .where("participants", arrayContains: userName)
        .snapshots();
  }

  //TASKS
}
