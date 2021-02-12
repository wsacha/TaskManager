import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/user_model.dart';
import 'package:task_manager/services/auth.dart';
import 'package:task_manager/utils/authenticate.dart';
import 'package:task_manager/utils/sharedpreferences.dart';

class HomeRoom extends StatefulWidget {
  HomeRoom({Key key}) : super(key: key);

  @override
  _HomeRoomState createState() => _HomeRoomState();
}

class _HomeRoomState extends State<HomeRoom> {
  AuthMethods authMethods = new AuthMethods();

  logoutUser() async {
    var state = Provider.of<UserDataModel>(context, listen: false);
    state.userName = "";
    state.userEmail = "";
    authMethods.signOut();
    await UserPreferenceFunctions.removeSavedValues();
    print("name: ${state.userName}, email: ${state.userEmail}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rooms'),
        actions: [
          GestureDetector(
              onTap: () async {
                await logoutUser();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Authenticate()));
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16), child: Icon(Icons.exit_to_app))),
        ],
      ),
      body: ListView(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          var state = Provider.of<UserDataModel>(context, listen: false);
          print("name: ${state.userName}, email: ${state.userEmail}");
        },
      ),
    );
  }

  newMethod() => UserPreferenceFunctions.removeSavedValues();
}
