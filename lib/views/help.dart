import 'package:flutter/material.dart';
import 'drawer.dart';

class help extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
      ),
      body: Center(
        child: Text('Version: Alpha 1.0.1'),
      ),
      drawer: NavigationDrawer(4, context),
      
    );
  }
}