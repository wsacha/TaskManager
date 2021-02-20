import 'package:flutter/material.dart';
import 'package:task_manager/services/database.dart';

class MemberInfo extends StatelessWidget {
  MemberInfo(this.memberName);

  final String memberName;
  final DatabaseMethods databaseMethods = new DatabaseMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Member info")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 60,
                  ),
                  Text(
                    memberName,
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            Divider(color: Colors.grey.shade400),
            Text(
              "Tasks",
              style: TextStyle(color: Colors.white, fontSize: 30),
            )
          ],
        ),
      ),
    );
  }
}
