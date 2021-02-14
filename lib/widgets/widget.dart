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
