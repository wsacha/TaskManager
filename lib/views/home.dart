import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/user_model.dart';
import 'package:task_manager/services/auth.dart';
import 'package:task_manager/services/database.dart';
import 'package:task_manager/utils/authenticate.dart';
import 'package:task_manager/utils/sharedpreferences.dart';

class HomeRoom extends StatefulWidget {
  HomeRoom({Key key}) : super(key: key);

  @override
  _HomeRoomState createState() => _HomeRoomState();
}

class _HomeRoomState extends State<HomeRoom> {
  @override
  void initState() {
    super.initState();
  }

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

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
    final userData = Provider.of<UserDataModel>(context, listen: false);
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
      body: StreamBuilder(
        stream: databaseMethods.getListOfRooms(userData.userName),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: ListView(
                  padding: EdgeInsets.all(12),
                  children: snapshot.data.docs.map((DocumentSnapshot doc) {
                    return ListTile(
                      tileColor: Colors.blue[400],
                      title: Text(doc.data()["roomTitle"] ?? "title"),
                      subtitle: Text(doc.data()["description"] ?? "no data"),
                      trailing: Icon(
                        Icons.arrow_forward_outlined,
                        size: 30,
                        color: Colors.white,
                      ),
                    );
                  }).toList()),
            ),
          );
        },
      ),
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
