import 'dart:io';

import 'package:college_events/model/firebass_scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:path/path.dart' as p;
import 'package:dio/dio.dart';

class DetailsView extends StatelessWidget {
  Map notice;
  DetailsView(this.notice);
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<FirebaseHandler>(
      builder: (context, child, model) {
        return Scaffold(
          appBar: AppBar(
            title: Text(" ${notice['title']}"),
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Text(
                      '${notice['title']}',
                      style: TextStyle(fontSize: 35),
                    ),
                    Text(
                      'Posted by: ${notice['author']}',
                      style: TextStyle(fontSize: 12),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                    ),
                    Container(
                      child: Text(
                        '${notice['details']}',
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            tooltip: 'Download Files',
            child: Icon(Icons.arrow_downward),
            onPressed: () {
              var i = 1;
              var dio = Dio();
              try {
                notice['files'].forEach((val) async {
                  // print(
                  //     '${notice['title']}-${notice['author']}-${notice['timeStamp']}-$i-$val');
                  var f =
                      '${notice['title']}-${notice['author']}-${notice['timeStamp']}-$i-$val';
                  var f2 = '${notice['title']}-$i-${DateTime.now().day}.$val';
                  i++;
                  var ref =
                      await model.storageReference.child(f).getDownloadURL();

                  var dir = '/storage/emulated/0/Evento';

                  Response response = await dio.download(
                      '$ref', '/storage/emulated/0/Evento/$f2');
                });
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('File(s) Downloading, Press Ok '),
                        content: Image.asset('assets/images/load.gif'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    });
              } catch (e) {
                print(e);
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text(
                            'Download Failed Check Your Internet Connection '),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    });
              }
            },
          ),
        );
      },
    );
  }
}
