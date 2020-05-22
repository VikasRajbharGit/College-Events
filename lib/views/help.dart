import 'package:flutter/material.dart';
import 'drawer.dart';

class help extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Center(
        child: Text('Version: Beta 1.0.0'),
      ),
      //drawer: NavigationDrawer(4, context),
      
    );
  }
}