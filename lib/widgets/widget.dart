import 'dart:ui';

import 'package:flutter/material.dart';

Widget appBarScreens(BuildContext context, String screenTitle) {
  return AppBar(
    title: Text('$screenTitle'),
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.white54),
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)));
}

InputDecoration alertTextFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff145C9E))));
}

TextStyle simpleTextStyle() {
  return TextStyle(color: Colors.white, fontSize: 16);
}

TextStyle mediumTextStyle() {
  return TextStyle(color: Colors.white, fontSize: 17);
}

showAlertDialog(BuildContext context, String text) {
  Widget cancelButton = FlatButton(
    child: Text('Cancel'),
    onPressed: () {},
  );

  return AlertDialog(
    title: Text("Error"),
    content: Text(text),
    actions: [cancelButton],
  );
}

SnackBar snackBarInfo(String text) {
  return SnackBar(
    content: Text(
      text,
      style: TextStyle(fontSize: 18),
    ),
    duration: Duration(seconds: 3),
  );
}

Future<bool> decisionAlertDialog(BuildContext context, String title, String content) async {
  return await showDialog(
      context: (context),
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            FlatButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            )
          ],
        );
      });
}

Future<bool> logoutAlertDialog(BuildContext context, String userName, String userEmail) async {
  return await showDialog(
      context: (context),
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                userName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                userEmail,
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          actions: [
            FlatButton(
              child: Text("Log out", style: TextStyle(fontSize: 20)),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            )
          ],
        );
      });
}
