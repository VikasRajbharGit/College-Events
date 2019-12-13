import 'package:college_events/model/firebass_scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'drawer.dart';
import 'package:college_events/util/text_styles.dart';

class Feedback extends StatefulWidget {
  @override
  _FeedbackState createState() => _FeedbackState();
}

class _FeedbackState extends State<Feedback> {
  TextEditingController _controller = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DateTime date = DateTime.now();
  var fbText='';
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<FirebaseHandler>(
        builder: (context, child, model) {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Feedback'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Form(
                key: formKey,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: Colors.black, width: 1.0)),
                  child: TextFormField(
                    validator: (val) =>
                        val.length < 1 ? 'Can not be Empty' : null,
                    //controller: _controller,
                    onSaved: (val){
                      fbText=val;
                    },
                    maxLines: 8,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'Feedback'),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  if(formKey.currentState.validate()){
                    formKey.currentState.save();
                    var fb = {
                    'feedback': fbText,
                    'date': DateTime.now().toLocal(),
                    'user': [
                      model.currentUser.email,
                      model.currentUser.displayName
                    ]
                  };
                  await model.db
                      .collection('feedbacks')
                      .document(
                          DateTime.now().millisecondsSinceEpoch.toString())
                      .setData(fb);
                  formKey.currentState.reset();
                  var sb = SnackBar(
                    content: Text('Feedback Submitted'),
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.green,
                  );
                  // Scaffold.of(context).showSnackBar(sb);
                  _scaffoldKey.currentState.showSnackBar(sb);
                  }
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width * 0.5,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Center(
                    child: Text(
                      'Submit',
                      style: high,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        drawer: NavigationDrawer(3, context),
      );
    });
  }
}
