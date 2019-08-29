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
        child: Text('Dial 123456'),
      ),
      drawer: NavigationDrawer(4, context),
      
    );
  }
}