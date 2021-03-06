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

  logoutUserAndClearDataInProvider() async {
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
    return WillPopScope(
      onWillPop: () => _logoutUser(context, userData.userName, userData.userEmail),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Rooms'),
          actions: [
            GestureDetector(
                onTap: () {
                  _logoutUser(context, userData.userName, userData.userEmail);
                },
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Icon(
                      Icons.exit_to_app,
                      size: 30,
                    ))),
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

            return (snapshot.data.docs.length != 0)
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    child: ListView(
                        padding: EdgeInsets.all(12),
                        children: snapshot.data.docs.map((DocumentSnapshot doc) {
                          return Card(
                            child: ListTile(
                              onLongPress: () async {
                                bool decision = await decisionAlertDialog(context, "Delete room",
                                    "Are you sure you want to delete this room?");
                                if (decision == true) {
                                  if ((userData.userName == doc.data()["owner"].toString())) {
                                    await databaseMethods.deleteRoomFromDb(doc.data()["id"]);
                                    await databaseMethods.deleteRoomMessages(doc.data()["id"]);
                                    await databaseMethods.deleteChatRoomFromDb(doc.data()["id"]);
                                    Scaffold.of(context)
                                        .showSnackBar(snackBarInfo("Room deleted successfully"));
                                  } else if (userData.userName != doc.data()["owner"].toString()) {
                                    Scaffold.of(context).showSnackBar(snackBarInfo(
                                        "You don't have permission to delete this room"));
                                  }
                                }
                              },
                              onTap: () async {
                                final roomData = Provider.of<RoomModel>(context, listen: false);
                                await roomData.resetValues();
                                print("${roomData.id} , ${roomData.isOwner} ");
                                roomData.id = doc.data()["id"];
                                if (userData.userName == doc.data()["owner"]) {
                                  roomData.isOwner = true;
                                }
                                Navigator.pushReplacement(
                                    context, MaterialPageRoute(builder: (context) => TaskPool()));
                              },
                              tileColor: Colors.lightBlue[300],
                              title: Text(
                                doc.data()["roomTitle"] ?? "title",
                                style: TextStyle(fontSize: 20),
                              ),
                              subtitle: Text(
                                doc.data()["description"] ?? "no data",
                                style: TextStyle(fontSize: 15),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_outlined,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                          );
                        }).toList()),
                  )
                : Center(
                    child: Text(
                    "No rooms",
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ));
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
                  var val = await joinRoomAlertDialog(context);
                  if (val != null) {
                    message = await databaseMethods.addUserToRoom(
                        userData.userName, val['id'], val['entryKey']);
                  }

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
      ),
    );
  }

  joinRoomAlertDialog(BuildContext context) async {
    final alertKey = GlobalKey<FormState>();
    TextEditingController idTextController = new TextEditingController();
    TextEditingController entryKeyTextController = new TextEditingController();
    return await showDialog(
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

  Future<bool> _logoutUser(BuildContext context, String userName, String userEmail) async {
    bool decision = await logoutAlertDialog(context, userName, userEmail);
    if (decision == true) {
      await logoutUserAndClearDataInProvider();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Authenticate()));
    }

    return Future.value(false);
  }
}
