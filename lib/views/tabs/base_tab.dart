import 'package:flutter/material.dart';

class CustomTab {
  final String appBarTitle;
  final List<Widget> appBarActions;
  final Builder body;
  final Widget floatingActionButton;

  CustomTab(
      {this.appBarTitle,
      this.appBarActions,
      this.body,
      this.floatingActionButton});
}
