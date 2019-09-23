import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_events/model/firebass_scoped_model.dart';
import 'package:college_events/views/tabs/create_screens/test.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dropdownitems.dart';
import 'package:file_picker/file_picker.dart';
import '../../../model/notice_model.dart';

class newNotice extends StatefulWidget {
  @override
  _newNoticeState createState() => _newNoticeState();
}

class _newNoticeState extends State<newNotice> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey= GlobalKey<ScaffoldState>();
  var toAll = false;
  Notice notice=Notice('', '', [], '', '', FieldValue.serverTimestamp());


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
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //mainAxisSize: MainAxisSize.min,
                    //direction: Axis.vertical,
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
                          decoration: InputDecoration(
                              hintText: 'Title', border: InputBorder.none),
                              onChanged: (val){
                                notice.title=val;
                              },
                        ),
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
                            hintText: 'Description',
                            border: InputBorder.none,
                          ),
                          onChanged: (val){
                            notice.details=val;
                          },
                          maxLines: 10,
                        ),
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
                      RaisedButton(
                        child: Text('Issue Notice'),
                        onPressed: () async {
                          if (!toAll) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => test()));
                          } else {
                            List urls;
                            //model.handleSubmit(formKey, notice)
                            try{
                               urls= await model.uploadToStorage(context, _scaffoldKey, model.fToUp);
                               print('xxxxx-------$urls');
                               
                            }
                            catch(e){
                               urls=['error'];
                            }
                            notice.audience='notification';
                            notice.author=model.currentUser.email;
                            notice.files=urls;
                            notice.timeStamp=FieldValue.serverTimestamp();
                            await model.handleSubmit(formKey, notice);
                            //model.imgUrls.removeRange(0, model.imgUrls.length);
                            Navigator.of(context).pop();
                          }
                        },
                      )
                    ],
                  ),
                )),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.attach_file),
            onPressed: () async {
              model.fToUp= await model.stageNoticeFiles(FileType.ANY);
            },
          ),
        );
      },
    );
  }
}
