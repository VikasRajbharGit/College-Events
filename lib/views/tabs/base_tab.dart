import 'package:flutter/material.dart';

class CustomTab {
  final String appBarTitle;
   List<Widget> appBarActions;
  final Builder body;
  final Widget floatingActionButton;
   BuildContext context;

  CustomTab(
      {this.appBarTitle,
      this.appBarActions,
      this.body,
      this.floatingActionButton,
      this.context});
}
