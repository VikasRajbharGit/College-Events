import 'package:college_events/model/firebass_scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dropdownitems.dart';

class newNotice extends StatefulWidget {
  @override
  _newNoticeState createState() => _newNoticeState();
}

class _newNoticeState extends State<newNotice> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List yearVal = [];
  List departmentsVal = ['1'];
  List divsVal = ['1'];
  var divs = compDivs;
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<FirebaseHandler>(
      builder: (context, child, model) {
        return Scaffold(
          appBar: AppBar(
            title: Text('New Notice'),
          ),
          body: Center(
            child: Form(
                key: formKey,
                child: ListView(
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      //direction: Axis.vertical,
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(hintText: 'Title'),
                        ),
                        TextFormField(
                          decoration: InputDecoration(hintText: 'Description'),
                        ),
                        FloatingActionButton(
                          child: Icon(Icons.attach_file),
                          onPressed: () {},
                        ),
                        Padding(
                          padding: EdgeInsets.all(20),
                        ),
                        
                        // FlatButton(
                        //   onPressed: () {},
                        //   child: Text('Issue Notice'),
                        // )
                      ],
                    ),
                  ],
                )),
          ),
        );
      },
    );
  }
}
