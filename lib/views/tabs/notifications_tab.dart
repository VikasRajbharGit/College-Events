import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../detail_view.dart';
import 'base_tab.dart';
import 'package:college_events/model/firebass_scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'create_screens/new_notice.dart';
import 'create_screens/test.dart';
import 'dart:io';

import 'expired_notices.dart';

CustomTab notificationsTab = CustomTab(
    appBarTitle: 'Notices',
    
    body: Builder(
      builder: (BuildContext context) {
        var height = MediaQuery.of(context).size.height;
        return ScopedModelDescendant<FirebaseHandler>(
          builder: (context, child, model) {
            return Center(
              child: StreamBuilder<QuerySnapshot>(
                  stream: model.db
                      .collection('notices')
                      .where('audience',
                          arrayContains: model.profile['subscriptions'][1])
                      .orderBy('deadline')
                      .orderBy('priority')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var snap = snapshot.data.documents.asMap();
                      //print(snap);
                      if(snap.length==0){
                        return Center(child: Text('No Notices'),);
                      }
                      return ListView.builder(
                        itemCount: snap.length,
                        itemBuilder: (_, index) {
                          if (DateTime.now().isAfter(
                              DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(snap[index].data['deadline'])))) {
                            model.handleSubmit(
                                snap[index].data, 'expired_notifications');
                            model.db
                                .collection('notices')
                                .document(snap[index].data['name'])
                                .delete();
                          }
                          var d =
                              DateTime.tryParse(snap[index].data['timeStamp']);
                          var dd = DateTime.fromMillisecondsSinceEpoch(
                              int.parse(snap[index].data['deadline']));
                          //print('-------dd--${d.day}/${d.month}/${d.year}');
                          return GestureDetector(
                            onDoubleTap: () {
                              model.bookMark(snap[index].data, 'notice');
                              showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (context) {
                                    return Center(
                                        child: Image.asset(
                                            'assets/images/source.gif'));
                                  });
                            },
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailsView(snap[index].data),
                                  ));
                            },
                            child: Container(
                              //padding: EdgeInsets.all(15),
                              margin: EdgeInsets.all(20),
                              height: MediaQuery.of(context).size.height * 0.28,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.purpleAccent[
                                          100], //Colors.grey[350],
                                      blurRadius: 12,
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.deepPurpleAccent,
                                        Colors.purpleAccent,
                                        Colors.blueAccent
                                      ])),
                              child: Card(
                                color: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                elevation: 0,
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        // Align(
                                        //   alignment: Alignment.centerRight,
                                        //   child: InkWell(
                                        //     onTap: () {
                                        //       model.bookmarks.containsKey(
                                        //               snap[index].data['title'])
                                        //           ? model.delBookMark(
                                        //               snap[index].data['title'])
                                        //           : model.bookMark(
                                        //               snap[index].data,
                                        //               'notice');
                                        //     },
                                        //     child: model.bookmarks.containsKey(
                                        //             snap[index].data['title'])
                                        //         ? Icon(
                                        //             Icons.bookmark,
                                        //             color: Colors.white,
                                        //             size: 35,
                                        //           )
                                        //         : Icon(
                                        //             Icons.bookmark_border,
                                        //             color: Colors.white,
                                        //             size: 35,
                                        //           ),
                                        //   ),
                                        // ),
                                        Hero(
                                          tag: snap[index].data['timeStamp'],
                                          child: Material(
                                            color: Colors.transparent,
                                            child: Text(
                                                "${snap[index].data['title']}",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 3,
                                                style: TextStyle(
                                                    fontFamily: 'Lexend Deca',
                                                    fontSize: 25,
                                                    color: Colors.white)),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(5),
                                        ),
                                        Text(
                                          'Posted by: ${snap[index].data['author']}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(5),
                                        ),
                                        Text(
                                          'Posted on: ${d.day}/${d.month}/${d.year}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(5),
                                        ),
                                        Text(
                                          'Deadline: ${dd.day}/${dd.month}/${dd.year}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(5),
                                        ),
                                        Text(
                                          '${snap[index].data['details']}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(
                          child: Image.asset('assets/images/simba.gif'));
                    }
                  }),
            );
          },
        );
      },
    ),
    floatingActionButton: ScopedModelDescendant<FirebaseHandler>(
        builder: (context, child, model) {
      return fab(model);
    }));

fab(model) {
  if (model.authority == 'teacher') {
    return Builder(builder: (context) {
      return FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          try {
            final result = await InternetAddress.lookup('google.com');
            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
              print('connected');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => newNotice()));
            }
          } on SocketException catch (_) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('No Internet'),
                    content: Text(
                        'Please check your internet Connection to access this feature'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                });
            print('not connected');
          }
        },
      );
    });
  } else {
    return SizedBox(
      height: 10,
      width: 10,
    );
  }
}

// Builder(builder: (context) {
//       return FloatingActionButton(
//         child: Icon(Icons.add),
//         onPressed: () {
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (BuildContext context) => newNotice()));
//         },
//       );
//     }));
