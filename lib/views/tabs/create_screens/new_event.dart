import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:college_events/model/firebass_scoped_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../model/event_model.dart';
import 'package:path/path.dart' as p;

class NewEvent extends StatefulWidget {
  @override
  _NewEventState createState() => _NewEventState();
}

class _NewEventState extends State<NewEvent> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Event event = Event('', '', [], '', '', '', '', '',
      DateTime.now().millisecondsSinceEpoch.toString());
  var categoryVal;
  var curDate = DateTime.now();
  var date = DateTime.now();
  Future<Null> _selectDate(BuildContext context) async {
    //print('------ddddd-----${date.month}');
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: curDate,
        firstDate: DateTime(curDate.month),
        lastDate: DateTime(DateTime.now().year).add(Duration(days: 365)));
    if (picked != null && picked != date)
      setState(() {
        date = picked;
        event.date = date.millisecondsSinceEpoch.toString();
      });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<FirebaseHandler>(
      builder: (context, child, model) {
        event.author = model.currentUser.email;
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('Add Event'),
          ),
          body: Center(
            child: Form(
                key: formKey,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.8,
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
                              event.title = val;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
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
                              event.details = val;
                            },
                            maxLines: 10,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                        ),
                        Row(
                          children: <Widget>[
                            Text('Event Date:'),
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
                                            "${DateFormat.yMMMMd("en_US").format(date)}"),
                                      ),
                                    ))),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
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
                            decoration: InputDecoration(
                              hintText: 'Registraion Link or Website',
                              border: InputBorder.none,
                            ),
                            onChanged: (val) {
                              event.link = val;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                        ),
                        Text('Category'),
                        RadioListTile(
                            title: Text('Cultural'),
                            groupValue: categoryVal,
                            value: 'cultural',
                            onChanged: (val) {
                              setState(() {
                                categoryVal = val;
                              });
                            }),
                        RadioListTile(
                            title: Text('Sports'),
                            groupValue: categoryVal,
                            value: 'sports',
                            onChanged: (val) {
                              setState(() {
                                categoryVal = val;
                              });
                            }),
                        RadioListTile(
                            title: Text('Technical'),
                            groupValue: categoryVal,
                            value: 'technical',
                            onChanged: (val) {
                              setState(() {
                                categoryVal = val;
                              });
                            }),
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
                                hintText: 'Committee',
                                border: InputBorder.none),
                            onChanged: (val) {
                              event.committee = val;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                        ),
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
                            keyboardType: TextInputType.phone,
                            validator: (val) =>
                                val.length != 10 ? 'Not valid Number' : null,
                            decoration: InputDecoration(
                                hintText: 'Contact', border: InputBorder.none),
                            onChanged: (val) {
                              event.contact = val;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Material(
                            borderRadius: BorderRadius.circular(10),
                            //type: MaterialType.transparency,
                            color: Theme.of(context).accentColor,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: MediaQuery.of(context).size.height * 0.05,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                focusColor: Colors.red,
                                splashColor: Colors.redAccent,
                                child: Center(
                                    child: Text(
                                  'Publish Event',
                                  style: TextStyle(color: Colors.white),
                                )),
                                onTap: () {
                                  if (formKey.currentState.validate()) {
                                    event.category = categoryVal;
                                    event.timeStamp = DateTime.now().toString();
                                    // try {
                                    //   model.fToUp
                                    //       .forEach((fileName, filePath) {
                                    //     event.files
                                    //         .add(p.extension(filePath));
                                    //   });
                                    // } catch (e) {
                                    //   //print(e);
                                    // }
                                    if (model.eventImage != null) {
                                      final StorageReference storageReference =
                                          FirebaseStorage.instance.ref();
                                      //var k = model.fToUp.keys.toList();
                                      //var f = model.fToUp[k[0]];

                                      var x = model.eventImage.path;
                                      final StorageUploadTask uploadTask =
                                          storageReference
                                              .child(
                                                  'event-${event.title}-${event.author}-${event.timeStamp}${p.extension(x)}')
                                              .putFile(
                                                model.eventImage,
                                              );
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          });
                                      uploadTask.onComplete
                                          .then((onValue) async {
                                        var temp =
                                            await onValue.ref.getDownloadURL();
                                        event.files.add(temp);

                                        model.handleSubmit(event, 'events');
                                        model.eventImage = null;
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      });
                                    } else {
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          });
                                      var date =
                                          DateTime.now().millisecondsSinceEpoch;
                                      event.name =
                                          event.title + '-' + date.toString();
                                      model.handleSubmit(event, 'events');
                                      model.eventImage = null;
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    }
                                  }
                                  // model.uploadToStorage(
                                  //     context,
                                  //     _scaffoldKey,
                                  //     model.fToUp,
                                  //     'event-${event.title}-${event.author}-${event.timeStamp}');
                                  // model.handleSubmit(formKey, event,'events');

                                  // showDialog(
                                  //     context: context,
                                  //     builder: (context) {
                                  //       return AlertDialog(
                                  //         content: Text("Posting, press OK"),
                                  //         // Image.asset(
                                  //         //   'assets/images/done.gif',
                                  //         //   //filterQuality: FilterQuality.low,
                                  //         // ),
                                  //         actions: <Widget>[
                                  //           FlatButton(
                                  //               child: Text('OK'),
                                  //               onPressed: () {
                                  //                 Navigator.of(context)
                                  //                     .pop();
                                  //               })
                                  //         ],
                                  //       );
                                  //     });
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
              //model.fToUp = await model.stageNoticeFiles(FileType.IMAGE);
              Future<File> img = ImagePicker.pickImage(
                      source: ImageSource.gallery,
                      maxHeight: 400,
                      maxWidth: 500)
                  .then((res) {
                model.eventImage = res;
                return res;
              });
              //model.eventImage=await img;
            },
          ),
        );
      },
    );
  }
}
