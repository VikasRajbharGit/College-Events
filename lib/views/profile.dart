import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:college_events/model/firebass_scoped_model.dart';
import 'drawer.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<FirebaseHandler>(
      builder: (context,child,model){
        return Scaffold(
          appBar: AppBar(
            title: Text('Profile'),
          ),
          body: Center(
            child: Column(
              children: <Widget>[
                CircleAvatar(
                      backgroundImage: model.ppic == null
                          ? AssetImage('assets/images/anim.gif')
                          : NetworkImage(model.ppic),
                      radius: 80,
                    ),
                Text(model.username,style: TextStyle(fontSize: 50),)
              ],
            )
          ),
          drawer: NavigationDrawer(2, context),
        );
      },
      
    );
  }
}