import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/models/room.dart';
import 'package:task_manager/providers/user_model.dart';
import 'package:task_manager/services/database.dart';
import 'package:task_manager/widgets/widget.dart';

class AddRoom extends StatefulWidget {
  AddRoom({Key key}) : super(key: key);

  @override
  _AddRoomState createState() => _AddRoomState();
}

class _AddRoomState extends State<AddRoom> {
  final formKey = GlobalKey<FormState>();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  TextEditingController roomTitleTextEditingController = new TextEditingController();
  TextEditingController descriptionTextEditingController = new TextEditingController();
  TextEditingController entryKeyTextEditingController = new TextEditingController();

  addRoom(String userName) async {
    if (formKey.currentState.validate()) {
      Room room = new Room(
          id: DateTime.now().millisecondsSinceEpoch.remainder(1000000).toString(),
          roomTitle: roomTitleTextEditingController.text,
          description: descriptionTextEditingController.text,
          entryKey: entryKeyTextEditingController.text,
          owner: userName,
          participants: [userName]);

      databaseMethods.addRoomToDb(room);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataModel>(context, listen: false);
    return Scaffold(
      appBar: appBarScreens(context, "Add new room"),
      body: SingleChildScrollView(
        child: Container(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 24,
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val) {
                          return val.isEmpty || val.length < 4 ? "Room title too short" : null;
                        },
                        controller: roomTitleTextEditingController,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration("Room title"),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        validator: (val) {
                          return val.isEmpty || val.length < 6 ? "Description too short" : null;
                        },
                        controller: descriptionTextEditingController,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration("Description"),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        validator: (val) {
                          return val.isEmpty || val.length < 4 ? "Entry key too short" : null;
                        },
                        controller: entryKeyTextEditingController,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration("Entry key"),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RaisedButton(
                      padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      color: Colors.red[500],
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    RaisedButton(
                      padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      color: Color(0xff145C9E),
                      child: Text("Add Room", style: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        await addRoom(userData.userName);
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
