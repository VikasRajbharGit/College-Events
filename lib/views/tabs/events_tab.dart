import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_events/model/firebass_scoped_model.dart';
import 'package:college_events/views/tabs/create_screens/new_event.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'base_tab.dart';
import '../detail_view.dart';
import '../event_details.dart';

CustomTab eventsTab = CustomTab(
    appBarTitle: 'Events',
    appBarActions: [],
    body: Builder(
      builder: (BuildContext context) {
        return ScopedModelDescendant<FirebaseHandler>(
            builder: (context, child, model) {
          return Center(
            child: StreamBuilder<QuerySnapshot>(
                stream: model.db.collection('events').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var snap = snapshot.data.documents.asMap();

                    return ListView.builder(
                      itemCount: snap.length,
                      itemBuilder: (_, index) {
                        getImg() async {
                          return await Image.network(
                            '${snap[index].data['files'][0]}',
                            fit: BoxFit.fill,
                            width: MediaQuery.of(context).size.width * 0.95,
                            height: MediaQuery.of(context).size.height * 0.25,
                          );
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
                          child: Card(
                            elevation: 15,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Container(
                                //height: MediaQuery.of(context).size.height * 0.25,
                                //width: MediaQuery.of(context).size.width * 0.8,
                                child: Hero(
                                  tag: snap[index].data['title'],
                                                                  child: Stack(
                              children: <Widget>[
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: FutureBuilder(
                                          future: getImg(),
                                          initialData: Image.asset('assets/images/valley.jpg'),
                                          builder: (context, snapshot) {
                                            return snapshot.data;
                                            // if (snapshot.connectionState ==
                                            //     ConnectionState.done) {
                                            //   // if (snapshot.hasError) {
                                            //   //   return Image.asset(
                                            //   //       'assets/images/valley.jpg');
                                            //   // } else {
                                            //   //   return snapshot.data;
                                            //   // }
                                              
                                            //   return snapshot.data;
                                            // } else {
                                            //   return Image.asset(
                                            //     'assets/images/load.gif',
                                            //     fit: BoxFit.scaleDown,
                                            //     width: MediaQuery.of(context)
                                            //             .size
                                            //             .width *
                                            //         0.95,
                                            //     height: MediaQuery.of(context)
                                            //             .size
                                            //             .height *
                                            //         0.25,
                                            //   );
                                            // }
                                            //return snapshot.data;
                                          }) //Image.asset(
                                      //'assets/images/valley.jpg',

                                      // width: MediaQuery.of(context).size.width*0.8 ,
                                      // height: MediaQuery.of(context).size.height * 0.01,
                                      // fit: BoxFit.fill,
                                      //),
                                      ),
                                  Stack(
                                    children: <Widget>[
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.25,
                                        width: MediaQuery.of(context).size.width *
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
                                          bottom: 10,
                                          left: 5,
                                          child: Text(
                                            '${snap[index].data['title']}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 25),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
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
    floatingActionButton: Builder(builder: (context) {
      return FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) => NewEvent()));
        },
      );
    }));
