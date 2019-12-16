import 'package:college_events/model/firebass_scoped_model.dart';
import 'package:college_events/views/tabs/create_screens/test.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:file_picker/file_picker.dart';
import '../../../model/notice_model.dart';
import 'dart:core';
import 'package:path/path.dart' as p;

class newNotice extends StatefulWidget {
  @override
  _newNoticeState createState() => _newNoticeState();
}

class _newNoticeState extends State<newNotice> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var toAll = false;
  Notice notice = Notice('', '', [], '', [], '');

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<FirebaseHandler>(
      builder: (context, child, model) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('New Notice'),
          ),
          body: Center(
            child: Form(
                key: formKey,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.85,
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded(
                        child: ListView(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                border: Border.all(
                                  color: Colors.black38,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: TextFormField(
                                validator: (val) =>
                                    val.length < 1 ? 'Can not be empty' : null,
                                decoration: InputDecoration(
                                    hintText: 'Title',
                                    border: InputBorder.none),
                                onChanged: (val) {
                                  notice.title = val;
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(20),
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Colors.white10,
                                  border: Border.all(
                                    color: Colors.black38,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(20)),
                              child: TextFormField(
                                validator: (val) =>
                                    val.length < 1 ? 'Can not be empty' : null,
                                decoration: InputDecoration(
                                  hintText: 'Description',
                                  border: InputBorder.none,
                                ),
                                onChanged: (val) {
                                  notice.details = val;
                                },
                                maxLines: 10,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                            ),
                            CheckboxListTile(
                              title: Text('Send To ALL'),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: toAll,
                              onChanged: (val) {
                                setState(() {
                                  toAll = val;
                                });
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.all(20),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Material(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).accentColor,
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(10),
                                    focusColor: Colors.red,
                                    splashColor: Colors.redAccent,
                                    child: Center(
                                        child: toAll
                                            ? Text(
                                                'Issue Notice',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            : Text(
                                                'Select Audience',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                    onTap: () {
                                      notice.author = model.currentUser.email;
                                      try {
                                        model.fToUp
                                            .forEach((fileName, filePath) {
                                          notice.files
                                              .add(p.extension(filePath));
                                        });
                                      } catch (e) {
                                        //print(e);
                                      }

                                      if (formKey.currentState.validate()) {
                                        if (!toAll) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      test(notice, formKey)));
                                        } else {
                                          List urls;
                                          notice.audience.add('notice');
                                          //model.handleSubmit(formKey, notice)
                                          try {
                                            //var lock = Lock();

                                            notice.timeStamp =
                                                DateTime.now().toString();
                                            model.uploadToStorage(
                                                context,
                                                _scaffoldKey,
                                                model.fToUp,
                                                '${notice.title}-${notice.author}-${notice.timeStamp}');

                                            

                                            model.handleSubmit(
                                                formKey, notice, 'notices');
                                            Navigator.of(context).pop();

                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    content: Text('Done'),
                                                    // Image.asset(
                                                    //   'assets/images/done.gif',
                                                    //   //filterQuality: FilterQuality.low,
                                                    // ),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                          child: Text('OK'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          })
                                                    ],
                                                  );
                                                });
                                          } catch (e) {
                                            urls = ['error'];
                                          }
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.attach_file),
            onPressed: () async {
              model.fToUp.clear();
              try {
                model.fToUp = await model.stageNoticeFiles(FileType.ANY);
              } catch (e) {
                print(e);
              }
            },
          ),
        );
      },
    );
  }
}
