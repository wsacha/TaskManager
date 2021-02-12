import 'package:flutter/material.dart';

class UserDataModel extends ChangeNotifier {
  String _userName;
  String _userEmail;

  UserDataModel([String name = "", String email = ""])
      : _userName = name,
        _userEmail = email;

  String get userName => _userName;
  set userName(String value) {
    _userName = value;
    notifyListeners();
  }

  String get userEmail => _userEmail;
  set userEmail(String value) {
    _userEmail = value;
    notifyListeners();
  }
}
