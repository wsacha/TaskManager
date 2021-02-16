import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomSideNav extends StatelessWidget {
  final Function setIndex;
  final int selectedIndex;

  CustomSideNav(this.selectedIndex, this.setIndex);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(),
    );
  }
}
