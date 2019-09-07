import 'package:flutter/material.dart';

class DetailsView extends StatelessWidget {
  Map event;
  DetailsView(this.event);
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        title: Text(" ${event['title']}"),
      ),
      
      
    );
  }
}