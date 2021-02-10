import 'package:flutter/material.dart';
import 'package:task_manager/services/auth.dart';
import 'package:task_manager/utils/authenticate.dart';
import 'package:task_manager/utils/helperfunctions.dart';

class HomeRoom extends StatefulWidget {
  HomeRoom({Key key}) : super(key: key);

  @override
  _HomeRoomState createState() => _HomeRoomState();
}

class _HomeRoomState extends State<HomeRoom> {
  AuthMethods authMethods = new AuthMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rooms'),
        actions: [
          GestureDetector(
              onTap: () async {
                authMethods.signOut();
                await UserPreferenceFunctions.removeSavedValues();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Authenticate()));
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16), child: Icon(Icons.exit_to_app))),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }

  newMethod() => UserPreferenceFunctions.removeSavedValues();
}
