import 'package:flutter/material.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/services/database.dart';
import 'package:task_manager/widgets/widget.dart';

class EditTask extends StatefulWidget {
  final Task task;
  EditTask(this.task);
  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  final formKey = GlobalKey<FormState>();

  TextEditingController newTaskTitleTextEditingController;
  TextEditingController newDescriptionTextEditingController;

  @override
  void initState() {
    newTaskTitleTextEditingController = new TextEditingController(text: widget.task.title);
    newDescriptionTextEditingController = new TextEditingController(text: widget.task.description);
    super.initState();
  }

  DateTime get dateTime => DateTime(widget.task.expirationDate.year,
      widget.task.expirationDate.month, widget.task.expirationDate.day);
  TimeOfDay get time =>
      TimeOfDay(hour: widget.task.expirationDate.hour, minute: widget.task.expirationDate.minute);
  DateTime newDateTime;
  TimeOfDay newTime;
  DateTime updatedDate;

  _editTask() {
    if (formKey.currentState.validate()) {
      if (newDateTime != null) {
        if (newTime != null) {
          updatedDate = new DateTime(
              newDateTime.year, newDateTime.month, newDateTime.day, newTime.hour, newTime.minute);
        } else {
          updatedDate = new DateTime(
              newDateTime.year, newDateTime.month, newDateTime.day, time.hour, time.minute);
        }
      } else {
        updatedDate =
            new DateTime(dateTime.year, dateTime.month, dateTime.day, time.hour, time.minute);
      }

      databaseMethods.updateTaskData(widget.task.id, newTaskTitleTextEditingController.text,
          newDescriptionTextEditingController.text, updatedDate);

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit task"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    TextFormField(
                      validator: (val) {
                        return val.isEmpty || val.length < 4 ? "Task title too short" : null;
                      },
                      controller: newTaskTitleTextEditingController,
                      style: simpleTextStyle(),
                      decoration: textFieldInputDecoration("Task"),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      validator: (val) {
                        return val.isEmpty || val.length < 6 ? "Description too short" : null;
                      },
                      controller: newDescriptionTextEditingController,
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
                            newDateTime == null
                                ? "${dateTime.toString().substring(0, 10)}"
                                : "${newDateTime.toString().substring(0, 10)}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Expanded(
                          child: RaisedButton.icon(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
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
                                initialDate: dateTime == null ? DateTime.now() : dateTime,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2050),
                              ).then((date) {
                                setState(() {
                                  newDateTime = date;
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
                            newTime == null
                                ? time.format(context).toString()
                                : newTime.format(context).toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Expanded(
                          child: RaisedButton.icon(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
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
                              TimeOfDay t =
                                  await showTimePicker(context: context, initialTime: time);
                              if (t != null) {
                                setState(() {
                                  newTime = t;
                                });
                              }
                            },
                          ),
                        ),
                      ],
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
                          child: Text("Edit task", style: TextStyle(color: Colors.white)),
                          onPressed: () async {
                            await _editTask();
                          },
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
