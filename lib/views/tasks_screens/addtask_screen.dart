import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/providers/room_model.dart';
import 'package:task_manager/providers/user_model.dart';
import 'package:task_manager/services/database.dart';
import 'package:task_manager/widgets/widget.dart';

class AddTask extends StatefulWidget {
  final bool isTaskToPool;

  AddTask(this.isTaskToPool);

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final formKey = GlobalKey<FormState>();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  DateTime _dateTime;
  TimeOfDay _time = TimeOfDay.now();
  TextEditingController taskTitleTextEditingController = new TextEditingController();
  TextEditingController descriptionTextEditingController = new TextEditingController();

  _addTask(String userName, String roomId) {
    if (formKey.currentState.validate() && _dateTime != null) {
      _dateTime =
          new DateTime(_dateTime.year, _dateTime.month, _dateTime.day, _time.hour, _time.minute);
      Task task = new Task(
          id: DateTime.now().millisecondsSinceEpoch.remainder(100000000).toString(),
          roomId: roomId,
          title: taskTitleTextEditingController.text,
          description: descriptionTextEditingController.text,
          attachedTo: widget.isTaskToPool ? "none" : userName,
          isDone: false,
          createdBy: userName,
          expirationDate: _dateTime);

      databaseMethods.addTaskToDb(task);

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataModel>(context, listen: false);
    final roomData = Provider.of<RoomModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Add task"),
      ),
      body: Builder(
        builder: (BuildContext context) => SingleChildScrollView(
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
                          return val.isEmpty || val.length < 4 ? "Task title too short" : null;
                        },
                        controller: taskTitleTextEditingController,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration("Task"),
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
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "Due date: ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              _dateTime == null ? "" : "${_dateTime.toString().substring(0, 10)}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Expanded(
                            child: RaisedButton.icon(
                              shape:
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                              color: Color(0xff145C9E),
                              label: Text(
                                "Date",
                                style: TextStyle(color: Colors.white),
                              ),
                              icon: Icon(
                                Icons.calendar_today,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: _dateTime == null ? DateTime.now() : _dateTime,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2050),
                                ).then((date) {
                                  setState(() {
                                    _dateTime = date;
                                  });
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "Due time: ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              _time == null ? "low" : _time.format(context).toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Expanded(
                            child: RaisedButton.icon(
                              shape:
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                              color: Color(0xff145C9E),
                              label: Text(
                                "Time",
                                style: TextStyle(color: Colors.white),
                              ),
                              icon: Icon(
                                Icons.access_time,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                TimeOfDay t = await showTimePicker(
                                    context: context, initialTime: TimeOfDay.now());
                                if (t != null) {
                                  setState(() {
                                    _time = t;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
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
                      child: Text("Add task", style: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        await _addTask(userData.userName, roomData.id);
                        if (_dateTime == null) {
                          Scaffold.of(context).showSnackBar(snackBarInfo("Please choose date"));
                        }
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
