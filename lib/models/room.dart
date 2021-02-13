class Room {
  String id;
  String owner;
  String roomTitle;
  List<String> participants;

  Room.fromMap(Map<String, dynamic> snapshot)
      : id = snapshot["id"],
        owner = snapshot["owner"],
        roomTitle = snapshot["roomTitle"],
        participants = snapshot["participants"];
}
