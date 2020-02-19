import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_events/model/firebass_scoped_model.dart';
import 'package:college_events/views/tabs/create_screens/new_event.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'base_tab.dart';
import '../detail_view.dart';
import '../event_details.dart';
import 'package:cached_network_image/cached_network_image.dart';

CustomTab eventsTab = CustomTab(
    appBarTitle: 'Events',
    appBarActions: [],
    body: Builder(
      builder: (BuildContext context) {
        return ScopedModelDescendant<FirebaseHandler>(
            builder: (context, child, model) {
          //print(model.bookmarks[0].data);
          return Center(
            child: StreamBuilder<QuerySnapshot>(
                stream: model.db
                    .collection('events')
                    .orderBy('timeStamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var snap = snapshot.data.documents.asMap();

                    return ListView.builder(
                      //scrollDirection: Axis.horizontal,
                      itemCount: snap.length,
                      itemBuilder: (_, index) {
                        var d= DateTime.tryParse(snap[index].data['timeStamp']);
                        getImg() {
                          try {
                            return CachedNetworkImage(
                              fadeInCurve: Curves.easeIn,
                              fadeInDuration: Duration(milliseconds: 300),
                              fadeOutCurve: Curves.bounceOut,
                              fadeOutDuration: Duration(milliseconds: 300),
                              alignment: Alignment.center,
                              imageUrl: snap[index].data['files'][0],
                              placeholder: (context, url) => Center(
                                  child: new Image.asset(
                                      'assets/images/load.gif')),
                              errorWidget: (context, url, error) =>
                                  new Icon(Icons.error),
                              fit: BoxFit.fill,
                            );
                          } catch (e) {
                            return Image.asset('assets/images/valley.jpg');
                          }
                        }

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EventsDetails(snap[index].data),
                                ));
                          },
                          onDoubleTap: () {
                            model.bookMark(snap[index].data, 'event');
                            showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) {
                                  return Center(
                                    child:
                                        Image.asset('assets/images/source.gif'),
                                  );
                                });
                          },
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            elevation: 15,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Container(
                                //height: MediaQuery.of(context).size.height * 0.25,
                                //width: MediaQuery.of(context).size.width * 0.95,
                                child: Hero(
                              tag: snap[index].data['title'],
                              child: Stack(
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.25,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.95,
                                        child: getImg()),
                                  ),
                                  Stack(
                                    children: <Widget>[
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.25,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.95,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                stops: [
                                                  0.6,
                                                  0.8,
                                                  1
                                                ],
                                                colors: [
                                                  Colors.transparent,
                                                  Color.fromRGBO(0, 0, 0, 0.7),
                                                  Color.fromRGBO(0, 0, 0, 0.9),
                                                ]),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                      Positioned(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          bottom: 10,
                                          left: 5,
                                          child: Text(
                                            '${snap[index].data['title']}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 25),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          )),
                                      // Positioned(
                                      //     right: 20,
                                      //     bottom: 15,
                                      //     // child: InkWell(
                                      //     //   splashColor: Colors.white,
                                      //     //   onTap: () {
                                      //     //     model.bookmarks.containsKey(
                                      //     //             snap[index].data['title'])
                                      //     //         ? model.delBookMark(
                                      //     //             snap[index].data['title'])
                                      //     //         : model.bookMark(
                                      //     //             snap[index].data,
                                      //     //             'event');
                                      //     //   },
                                      //     //   child: model.bookmarks.containsKey(
                                      //     //           snap[index].data['title'])
                                      //     //       ? Icon(
                                      //     //           Icons.bookmark,
                                      //     //           color: Colors.white,
                                      //     //           size: 35,
                                      //     //         )
                                      //     //       : Icon(
                                      //     //           Icons.bookmark_border,
                                      //     //           color: Colors.white,
                                      //     //           size: 35,
                                      //     //         ),
                                      //     // )
                                      //     )
                                    ],
                                  ),
                                  // Padding(
                                  //   padding: EdgeInsets.all(5),
                                  // ),
                                  // Center(
                                  //   child: Text(
                                  //     'Event ${index + 1}',
                                  //     style: TextStyle(fontSize: 30),
                                  //   ),
                                  // )
                                ],
                              ),
                            )),
                          ),
                        );
                      },
                    );
                  } else {
                    return Text('loading');
                  }
                }),
          );
        });
      },
    ),
    floatingActionButton: ScopedModelDescendant<FirebaseHandler>(
        builder: (context, child, model) {
      return fab(model);
    }));

fab(model) {
  if (model.authority == 'moderator' || model.authority == 'teacher') {
    return Builder(builder: (context) {
      return FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: ()async {
          try {
            final result = await InternetAddress.lookup('google.com');
            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
              print('connected');
               Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) => NewEvent()));
            }
          } on SocketException catch (_) {
            showDialog(
              context: context,
              builder: (context){
                return AlertDialog(
                  title: Text('No Internet'),
                  content: Text('Please check your internet Connection to access this feature'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('OK'),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    )
                  ],
                );
              }
            );
            print('not connected');
          }
         
        },
      );
    });
  }
  else {
    return SizedBox(height: 10,width: 10,);
  }
}
