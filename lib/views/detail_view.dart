import 'dart:io';
import 'dart:math' as math;
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
    var size = (2 + notice['title'].length / 10) * 45; //300.0;

    return ScopedModelDescendant<FirebaseHandler>(
      builder: (context, child, model) {
        return Scaffold(
          appBar: AppBar(
            title: Text(" ${notice['title']}"),
          ),
          body: CustomScrollView(slivers: [
            SliverPersistentHeader(
              //pinned: true,
              delegate: _SliverAppBarDelegate(
                minHeight: 5,
                maxHeight: size, //MediaQuery.of(context).size.height * 0.5,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        child: ListView(
                          children: <Widget>[
                            Hero(
                              tag: notice['timeStamp'],
                              child: Material(
                                child: Text(
                                  '${notice['title']}',
                                  style: TextStyle(fontSize: 45),
                                ),
                              ),
                            ),
                            Text(
                              'Posted by: ${notice['author']}',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverFillViewport(
              viewportFraction: 1.03,
              delegate: SliverChildListDelegate([
                // Padding(
                //   padding: EdgeInsets.all(20),
                // ),
                Card(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15))),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      '${notice['details']}',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                ),
              ]),
            ),
          ]),
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
                      if (notice['files'].length == 0) {
                        return AlertDialog(
                          content: Text('No files Attached'),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            )
                          ],
                        );
                      }
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
                        content: Text('No files Attached '),
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

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // return new SizedBox(
    //   child: child,
    // );
    return Container(
      child: child,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
