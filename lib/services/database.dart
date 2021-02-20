import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_manager/models/room.dart';
import 'package:task_manager/models/task.dart';

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
  getRoomInfo(String id) {
    return FirebaseFirestore.instance.collection("rooms").where("id", isEqualTo: id).get();
  }

  getListOfRooms(userName) {
    return FirebaseFirestore.instance
        .collection("rooms")
        .where("participants", arrayContains: userName)
        .snapshots();
  }

  getRoomById(String id) {
    return FirebaseFirestore.instance.collection("rooms").doc(id).snapshots();
  }

  addRoomToDb(Room room) {
    return FirebaseFirestore.instance.collection("rooms").doc(room.id).set(room.toJson());
  }

  deleteRoomFromDb(String id) {
    return FirebaseFirestore.instance
        .collection("rooms")
        .doc(id)
        .delete()
        .catchError((val) => null);
  }

  Future<String> addUserToRoom(String userName, String id, String entryKey) async {
    try {
      var query = await FirebaseFirestore.instance
          .collection("rooms")
          .where("id", isEqualTo: id)
          .where("entryKey", isEqualTo: entryKey)
          .limit(1)
          .get();

      final doc = query.docs[0];
      List<dynamic> participants = doc.data()["participants"];
      if (!participants.contains(userName)) {
        participants.add(userName);
        doc.reference.update({'participants': participants});
        return "User has joined to room";
      }
      return "User already in room";
    } catch (e) {
      return "Invalid data";
    }
    // return FirebaseFirestore.instance
    //     .collection("rooms")
    //     .where("id", isEqualTo: id)
    //     .where("entryKey", isEqualTo: entryKey)
    //     .limit(1)
    //     .get()
    //     .then((query) {
    //   final doc = query.docs[0];
    //   List<dynamic> participants = doc.data()["participants"];
    //   if (!participants.contains(userName)) {
    //     participants.add(userName);
    //     doc.reference.update({'participants': participants});
    //     return "User has joined to room";
    //   }
    //   return "User Already in room";
    // }).catchError((error, stackTrace) {
    //   return "Invalid data";
    // });
  }

  Future<String> addUserByAdminToRoom(String id, String userName) async {
    try {
      await FirebaseFirestore.instance.collection("rooms").doc(id).update({
        "participants": FieldValue.arrayUnion([userName])
      });
      return "User added";
    } catch (e) {
      return Future.error("error $e");
    }
  }

  //TASKS
  addTaskToDb(Task task) {
    return FirebaseFirestore.instance.collection("tasks").doc(task.id).set(task.toJson());
  }

  getTaskPool(String roomId, String attachedTo, bool isDone) {
    return FirebaseFirestore.instance
        .collection("tasks")
        .where("roomId", isEqualTo: roomId)
        .where("attachedTo", isEqualTo: attachedTo)
        .where("isDone", isEqualTo: isDone)
        .orderBy("expirationDate", descending: false)
        .snapshots();
  }

  deleteTaskFromDb(String id) {
    return FirebaseFirestore.instance
        .collection("tasks")
        .doc(id)
        .delete()
        .catchError((val) => null);
  }

  void attachTaskToUser(String id, String userName) {
    try {
      FirebaseFirestore.instance.collection("tasks").doc(id).update({"attachedTo": userName});
      print("task attached");
    } catch (e) {
      print(e);
    }
  }

  markTaskAsDone(String id) {
    return FirebaseFirestore.instance.collection("tasks").doc(id).update({"isDone": true});
  }

  void updateTaskData(String id, String title, String description, DateTime updatedDate) {
    try {
      FirebaseFirestore.instance.collection("tasks").doc(id).update({
        "title": title,
        "description": description,
        "expirationDate": Timestamp.fromDate(updatedDate)
      });
      print("User updated");
    } catch (e) {
      print("failed to update user: $e");
    }
  }
}
