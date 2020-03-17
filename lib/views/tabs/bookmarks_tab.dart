import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_events/model/firebass_scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../detail_view.dart';
import '../event_details.dart';
import 'base_tab.dart';

CustomTab bookmarksTab = CustomTab(
    appBarTitle: 'Bookmarks',
    appBarActions: [],
    body: Builder(
      builder: (BuildContext context) {
        return ScopedModelDescendant<FirebaseHandler>(
            builder: (context, child, model) {
          return Center(
            child: StreamBuilder<QuerySnapshot>(
                stream: model.db
                    .collection('users')
                    .document(model.currentUser.email)
                    .collection('bookmarks').orderBy('BMtime',descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var snap = snapshot.data.documents.asMap();
                    if(snap.length==0){
                        return Center(child: Text('No Bookmarks'),);
                      }
                    return ListView.builder(
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
                        // getImg() async {
                        //   return await Image.network(
                        //     '${snap[index].data['files'][0]}',
                        //     fit: BoxFit.fill,
                        //     width: MediaQuery.of(context).size.width * 0.95,
                        //     height: MediaQuery.of(context).size.height * 0.25,
                        //   );
                        // }

                        if (snap[index].data['type'] == 'event') {
                          return GestureDetector(
                            onDoubleTap: () {
                              model.delBookMark(snap[index].data['name']);
                              showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (context) {
                                    return Center(
                                      child: Image.asset(
                                          'assets/images/source.gif'),
                                    );
                                  });
                            },
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EventsDetails(snap[index].data),
                                  ));
                            },
                            child: Card(
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
                                        child: getImg()
                                      ),
                                    ),
                                    Stack(
                                      children: <Widget>[
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.25,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
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
                                                    Color.fromRGBO(
                                                        0, 0, 0, 0.7),
                                                    Color.fromRGBO(
                                                        0, 0, 0, 0.9),
                                                  ]),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        ),
                                        Positioned(
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
                                        Positioned(
                                            right: 20,
                                            bottom: 20,
                                            child: GestureDetector(
                                              onTap: () {
                                                model.delBookMark(
                                                        snap[index]
                                                            .data['name']);
                                              },
                                              child: Icon(
                                                      Icons.bookmark,
                                                      color: Colors.white,
                                                      size: 35,
                                                    )
                                            ))
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
                        } else {
                          return GestureDetector(
                            onDoubleTap: () {
                              model.delBookMark(snap[index].data['name']);
                              showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (context) {
                                    return Center(
                                      child: Image.asset(
                                          'assets/images/source.gif'),
                                    );
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
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: GestureDetector(
                                            onTap: () {
                                              model.delBookMark(
                                                  snap[index].data['name']);
                                            },
                                            child: Icon(
                                              Icons.bookmark,
                                              color: Colors.white,
                                              size: 35,
                                            ),
                                          ),
                                        ),
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
                                          '${snap[index].data['details']}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
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
                        }
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
    floatingActionButton: null);
