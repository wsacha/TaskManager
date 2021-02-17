import 'package:flutter/cupertino.dart';

class RoomModel extends ChangeNotifier {
  String _id;
  bool _isOwner;

  RoomModel([String id = "", bool isOwner = false])
      : _id = id,
        _isOwner = isOwner;

  String get id => _id;
  set id(String value) {
    _id = value;
    notifyListeners();
  }

  bool get isOwner => _isOwner;
  set isOwner(bool value) {
    _isOwner = value;
    notifyListeners();
  }

  resetValues() {
    _id = "";
    _isOwner = false;
  }
}
