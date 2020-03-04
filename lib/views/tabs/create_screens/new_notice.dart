import 'package:college_events/model/firebass_scoped_model.dart';
import 'package:college_events/views/tabs/create_screens/test.dart';
import 'package:intl/intl.dart';
import 'dropdownitems.dart';
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
  var priority = '3';
  var deadline = DateTime.now();
  Notice notice = Notice('', '', [], '', [], '', 'low',
      DateTime.now().millisecondsSinceEpoch.toString());
  var date = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    //print('------ddddd-----${date.month}');
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(date.month),
        lastDate: DateTime(DateTime.now().year).add(Duration(days: 365)));
    if (picked != null && picked != deadline)
      setState(() {
        deadline = picked;
        notice.deadline = deadline.millisecondsSinceEpoch.toString();
      });
  }

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
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                hintText: 'Title', border: InputBorder.none),
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
                        Row(
                          children: <Widget>[
                            Text('Deadline:'),
                            SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                                onTap: () {
                                  _selectDate(context);
                                },
                                child: Card(
                                    elevation: 0,
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      child: Center(
                                        child: Text(
                                            "${DateFormat.yMMMMd("en_US").format(deadline)}"),
                                      ),
                                    ))),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                        ),
                        Text('Priority:'),
                        Padding(
                          padding: EdgeInsets.all(5),
                        ),
                        RadioListTile(
                            title: Text('Low'),
                            groupValue: priority,
                            value: '3',
                            onChanged: (val) {
                              notice.priority = val;
                              setState(() {
                                priority = val;
                              });
                            }),
                        RadioListTile(
                            title: Text('Moderate'),
                            groupValue: priority,
                            value: '2',
                            onChanged: (val) {
                              notice.priority = val;
                              setState(() {
                                priority = val;
                              });
                            }),
                        RadioListTile(
                            title: Text('High'),
                            groupValue: priority,
                            value: '1',
                            onChanged: (val) {
                              notice.priority = val;
                              setState(() {
                                priority = val;
                              });
                            }),
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
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.height * 0.05,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                focusColor: Colors.red,
                                splashColor: Colors.redAccent,
                                child: Center(
                                    child: toAll
                                        ? Text(
                                            'Issue Notice',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        : Text(
                                            'Select Audience',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                onTap: () {
                                  notice.author = model.currentUser.email;
                                  try {
                                    model.fToUp.forEach((fileName, filePath) {
                                      notice.files.add(p.extension(filePath));
                                    });
                                  } catch (e) {
                                    //print(e);
                                  }

                                  if (formKey.currentState.validate()) {
                                    if (!toAll) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  test(notice, formKey)));
                                    } else {
                                      List urls;
                                      notice.audience.addAll(allTopics);
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

                                        print(notice.toJson());
                                        if (formKey.currentState.validate()) {
                                          model.handleSubmit(notice, 'notices');
                                        }
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
                                                        Navigator.of(context)
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
