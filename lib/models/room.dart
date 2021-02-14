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
}
