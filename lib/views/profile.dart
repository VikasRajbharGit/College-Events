import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:college_events/model/firebass_scoped_model.dart';
import 'drawer.dart';
import 'package:share/share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:http/http.dart' show get;
import 'package:file_picker/file_picker.dart';
import 'registeration.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  AnimationController _controller;
  AnimationController _animationController;
  Animation<double> animation;
  double radius = 0;
  var profile;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    _animationController =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    // animation = CurvedAnimation(parent: _controller, curve: Curves.bounceIn)
    //   ..addListener(() {
    //     print(animation.value);
    //   });
    animation = Tween<double>(begin: 0, end: 80).animate(_controller);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<FirebaseHandler>(
      builder: (context, child, model) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('Profile'),
          ),
          body: Center(
              child: SingleChildScrollView(
            child: Column(children: <Widget>[
              AnimatedBuilder(
                animation: _controller,
                builder: (context, widget) {
                  //getprofile();
                  _controller.forward();
                  // if (_controller.isCompleted) {
                  //   _controller.reset();
                  // }

                  return GestureDetector(
                    onLongPress: () {
                      handle(model);
                    },
                    child: CircleAvatar(
                      backgroundImage: model.ppic == null
                          ? AssetImage('assets/images/anim.gif')
                          : NetworkImage(model.ppic),
                      radius: animation.value,
                    ),
                  );
                },
              ),
              Text(
                model.username,
                style: TextStyle(fontSize: 50),
              ),
              // RaisedButton(
              //   onPressed: () {
              //     //model.saveDeviceToken(['notices']);
              //     Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => register()));
              //   },
              //   child: Text('Register'),
              // ),
              Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
              ),
              Card(
                margin: EdgeInsets.all(15),
                child: Container(
                    padding: EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      child: prof(model),
                    )),
              )
            ]),
          )),
          drawer: NavigationDrawer(2, context),
        );
      },
    );
  }

  prof(model) {
    if (model.profile != null) {
      return Column(
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Name:'),
                Chip(
                  label: Text(model.profile['name']),
                  backgroundColor: Colors.grey,
                ),
              ]),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('ID:'),
                Chip(
                  label: Text(model.profile['college_id']),
                  backgroundColor: Colors.grey,
                ),
              ]),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('year:'),
                Chip(
                  label: Text(model.profile['year']),
                  backgroundColor: Colors.grey,
                ),
              ]),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('branch:'),
                Chip(
                  label: Text(model.profile['branch']),
                  backgroundColor: Colors.grey,
                ),
              ]),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('div:'),
                Chip(
                  label: Text(model.profile['div']),
                  backgroundColor: Colors.grey,
                ),
              ]),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Roll no.:'),
                Chip(
                  label: Text(model.profile['roll_no']),
                  backgroundColor: Colors.grey,
                ),
              ]),
        ],
      );
    } else {
      return SizedBox(height: 10, width: 10);
    }
  }

  handle(model) async {
    //var dir1 = await getApplicationDocumentsDirectory();
    //print(dir1.path);
    //Share.share('Hello');
    var img = await get(model.ppic).then((value) {
      //model.ppic is image address
      return value.bodyBytes;
    });
    var d = await new Directory('/storage/emulated/0/Evento').create();
    var dir = '/storage/emulated/0/Evento';
    File file = new File(join(dir, 'imagetest2.png'));
    file.writeAsBytesSync(img);
    // final uri = Uri.file('/storage/emulated/0/Evento/imagetest2.png');
    // SimpleShare.share(uri: uri.toString(), title: 'testing', msg: 'Test');
  }
}
