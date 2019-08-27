import 'package:college_events/util/text_styles.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:college_events/model/firebass_scoped_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:college_events/util/text_styles.dart';

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<FirebaseHandler>(
      builder: (context, child, model) {
        return Scaffold(
          appBar: AppBar(
            title:
                const Text('Home', style: TextStyle(fontFamily: 'Lexend Deca')),
            actions: <Widget>[IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed:(){model.gSignOut(context);},
            )],
          ),

          body: Center(
            child: Text('Welcome, ${model.username}',style: TextStyle(fontFamily: 'Lexend Deca',fontSize: 50,color: Colors.blue[800]),),
          ),
        );
      },
    );
  }
}
