import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/room_model.dart';
import 'package:task_manager/providers/user_model.dart';
import 'package:task_manager/services/auth.dart';
import 'package:task_manager/services/database.dart';
import 'package:task_manager/utils/authenticate.dart';
import 'package:task_manager/utils/sharedpreferences.dart';
import 'package:task_manager/views/addroom_screen.dart';
import 'package:task_manager/views/taskpool_screen.dart';
import 'package:task_manager/widgets/task_widgets.dart';
import 'package:task_manager/widgets/widget.dart';

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
              onTap: () {
                decisionAlertDialog(context, "Logout", "Are you sure you want to to log out?")
                    .then((val) async {
                  if (val == true) {
                    await logoutUser();
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => Authenticate()));
                  }
                });
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

          return Container(
            width: MediaQuery.of(context).size.width,
            child: ListView(
                padding: EdgeInsets.all(12),
                children: snapshot.data.docs.map((DocumentSnapshot doc) {
                  return Card(
                    child: ListTile(
                      focusColor: Colors.red,
                      onLongPress: () {
                        decisionAlertDialog(context, "Delete room",
                                "Are you sure you want to delete this room?")
                            .then((val) async {
                          if ((val == true) &&
                              (userData.userName == doc.data()["owner"].toString())) {
                            databaseMethods.deleteRoomFromDb(doc.data()["id"]);
                            Scaffold.of(context)
                                .showSnackBar(snackBarInfo("Room deleted successfully"));
                          } else if (userData.userName != doc.data()["owner"].toString()) {
                            Scaffold.of(context).showSnackBar(
                                snackBarInfo("You don't have permission to delete this room"));
                          }
                        });
                      },
                      onTap: () {
                        final roomData = Provider.of<RoomModel>(context, listen: false);
                        print("${roomData.id} , ${roomData.isOwner} ");
                        roomData.id = doc.data()["id"];
                        if (userData.userName == doc.data()["owner"]) {
                          roomData.isOwner = true;
                        }
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => TaskPool()));
                      },
                      tileColor: Colors.lightBlue[300],
                      title: Text(doc.data()["roomTitle"] ?? "title"),
                      subtitle: Text(doc.data()["description"] ?? "no data"),
                      trailing: Icon(
                        Icons.arrow_forward_outlined,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  );
                }).toList()),
          );
        },
      ),
      floatingActionButton: Builder(builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "btn1",
              child: Icon(Icons.search),
              onPressed: () async {
                var message;
                await joinRoomAlertDialog(context).then((val) async {
                  if (val != null) {
                    message = await databaseMethods.addUserToRoom(
                        userData.userName, val['id'], val['entryKey']);
                  }
                });
                if (message != null) {
                  Scaffold.of(context).showSnackBar(snackBarInfo(message));
                }
              },
            ),
            SizedBox(
              height: 15,
            ),
            FloatingActionButton(
              heroTag: "btn2",
              child: Icon(Icons.add),
              onPressed: () {
                print("name: ${userData.userName}, email: ${userData.userEmail}");
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddRoom()));
              },
            ),
          ],
        );
      }),
    );
  }

  joinRoomAlertDialog(BuildContext context) {
    final alertKey = GlobalKey<FormState>();
    TextEditingController idTextController = new TextEditingController();
    TextEditingController entryKeyTextController = new TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: AlertDialog(
                    title: Text("Join room"),
                    content: Column(
                      children: [
                        Form(
                          key: alertKey,
                          child: Column(
                            children: [
                              TextFormField(
                                validator: (val) {
                                  return val.isEmpty ? "Enter Room ID" : null;
                                },
                                controller: idTextController,
                                decoration: alertTextFieldInputDecoration("Room ID"),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                validator: (val) {
                                  return val.isEmpty ? "Enter Entry key" : null;
                                },
                                controller: entryKeyTextController,
                                decoration: alertTextFieldInputDecoration("Entry key"),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    actions: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FlatButton(
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            child: Text("Submit"),
                            onPressed: () {
                              if (alertKey.currentState.validate()) {
                                Navigator.of(context).pop({
                                  "id": idTextController.text.toString(),
                                  "entryKey": entryKeyTextController.text.toString()
                                });
                              }
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
