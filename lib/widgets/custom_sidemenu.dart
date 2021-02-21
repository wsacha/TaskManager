import 'package:flutter/material.dart';
import 'package:task_manager/views/home.dart';
import 'package:task_manager/widgets/task_widgets.dart';

class CustomSideNav extends StatelessWidget {
  final Function setIndex;
  final int selectedIndex;

  CustomSideNav(this.selectedIndex, this.setIndex);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.grey[850],
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Menu', style: TextStyle(color: Colors.blue[400], fontSize: 30)),
            ),
            Divider(color: Colors.grey.shade400),
            Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.assignment,
                    color: Colors.white,
                  ),
                  title: navText("Task pool"),
                  onTap: () {
                    navItemClicked(context, 0);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.library_books_rounded,
                    color: Colors.white,
                  ),
                  title: navText("My Tasks"),
                  onTap: () {
                    navItemClicked(context, 1);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.history,
                    color: Colors.white,
                  ),
                  title: navText("Finished tasks"),
                  onTap: () {
                    navItemClicked(context, 2);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.people,
                    color: Colors.white,
                  ),
                  title: navText("Members"),
                  onTap: () {
                    navItemClicked(context, 3);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.chat,
                    color: Colors.white,
                  ),
                  title: navText("Team chat"),
                  onTap: () {
                    navItemClicked(context, 4);
                  },
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Divider(color: Colors.grey.shade400),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ListTile(
                  leading: Icon(
                    Icons.info_outline,
                    color: Colors.white,
                  ),
                  title: navText("About room"),
                  onTap: () {
                    navItemClicked(context, 5);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.exit_to_app_rounded,
                    color: Colors.white,
                  ),
                  title: navText("Exit"),
                  onTap: () {
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => HomeRoom()));
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  navItemClicked(BuildContext context, int index) {
    setIndex(index);
    Navigator.of(context).pop();
  }
}
