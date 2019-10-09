import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:college_events/model/firebass_scoped_model.dart';
import 'drawer.dart';
import 'package:share/share.dart';
import 'package:simple_share/simple_share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:http/http.dart' show get;
import 'package:file_picker/file_picker.dart';

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
        return Builder(
          builder: (context) {
            return Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                title: Text('Profile'),
              ),
              body: Builder(
                builder: (context1) {
                  return Center(
                      child: Column(
                    children: <Widget>[
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, widget) {
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
                      RaisedButton(
                        onPressed: () {
                          model.saveDeviceToken();
                        },
                        child: Text('Generate Token'),
                      ),
                      RaisedButton(
                          onPressed: () async {
                            // var storageReference =
                            //     FirebaseStorage.instance.ref();
                            // final StorageUploadTask uploadTask =
                            //     storageReference.child('test.png').putFile(
                            //           File(
                            //               '/storage/emulated/0/Evento/imagetest2.png'),
                            //         );
                            // var d='not yet';
                            // var dUrl=uploadTask.onComplete.then((onValue)async{
                            //   d= await onValue.ref.getDownloadURL();
                            //   print('--$d');
                            // });
                            // print(d);
                            //Map<String,String> paths = await model.stageNoticeFiles(FileType.IMAGE);
                            //print('-------xxxxx $paths');
                            //await model.uploadToStorage(context, _scaffoldKey, paths);
                            showBottomSheet(
                              builder: (context) {
                                return BottomSheet(
                                  elevation: 10,
                                  animationController: _animationController,
                                  builder: (context1) {
                                    return Container(
                                        child: Container(
                                      height: 500,
                                      color: Colors.red,
                                      child: Text('Hello'),
                                    ) //Image.asset('assets/images/load.gif'),
                                        );
                                  },
                                  onClosing: () {
                                    Navigator.of(context1).pop();
                                  },
                                );
                              },
                              context: context1,
                            );
                          },
                          child: Text('Upload image')),
                      Expanded(
                        child: ListView.builder(
                          itemCount: model.imgUrls.length,
                          itemBuilder: (_, index) {
                            return Image.network(model.imgUrls[index]);
                          },
                        ),
                      )
                    ],
                  ));
                },
              ),
              drawer: NavigationDrawer(2, context),
            );
          },
        );
      },
    );
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
    final uri = Uri.file('/storage/emulated/0/Evento/imagetest2.png');
    SimpleShare.share(uri: uri.toString(), title: 'testing', msg: 'Test');
  }
}
