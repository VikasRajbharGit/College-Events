import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../detail_view.dart';
import 'base_tab.dart';
import 'package:college_events/model/firebass_scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'create_screens/new_notice.dart';
import 'create_screens/test.dart';

CustomTab notificationsTab = CustomTab(
    appBarTitle: 'Notices',
    appBarActions: [],
    body: Builder(
      builder: (BuildContext context) {
        var height = MediaQuery.of(context).size.height;
        return ScopedModelDescendant<FirebaseHandler>(
          builder: (context, child, model) {
            return Center(
              child: StreamBuilder<QuerySnapshot>(
                  stream: model.db.collection('notices').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var snap = snapshot.data.documents.asMap();
                      return ListView.builder(
                        itemCount: snap.length,
                        itemBuilder: (_, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailsView(snap[index].data),
                                  ));
                            },
                            child: Align(
                              alignment: index % 2 == 0
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    height: height * 0.43,
                                    width: MediaQuery.of(context).size.width *
                                        0.55,
                                    child: ClipRRect(
                                      borderRadius: index % 2 == 0
                                          ? BorderRadius.only(
                                              topLeft:
                                                  Radius.circular(height * 0.5),
                                              bottomLeft:
                                                  Radius.circular(height * 0.5))
                                          : BorderRadius.only(
                                              topRight:
                                                  Radius.circular(height * 0.5),
                                              bottomRight: Radius.circular(
                                                  height * 0.5)),
                                      child: Image.asset(
                                        'assets/images/lake.jpeg',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Opacity(
                                    opacity: 0.8,
                                    child: ClipRRect(
                                      borderRadius: index % 2 == 0
                                          ? BorderRadius.only(
                                              topLeft:
                                                  Radius.circular(height * 0.5),
                                              bottomLeft:
                                                  Radius.circular(height * 0.5))
                                          : BorderRadius.only(
                                              topRight:
                                                  Radius.circular(height * 0.5),
                                              bottomRight: Radius.circular(
                                                  height * 0.5)),
                                      child: Container(
                                        height: height * 0.43,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.55,
                                        decoration: BoxDecoration(
                                            borderRadius: index % 2 == 0
                                                ? BorderRadius.only(
                                                    topLeft: Radius.circular(
                                                        height * 0.5),
                                                    bottomLeft: Radius.circular(
                                                        height * 0.5))
                                                : BorderRadius.only(
                                                    topRight: Radius.circular(
                                                        height * 0.5),
                                                    bottomRight:
                                                        Radius.circular(
                                                            height * 0.5)),
                                            color: Colors.pink),
                                        child: Column(
                                          children: <Widget>[
                                            Expanded(
                                              child: Container(
                                                margin: index & 2 == 0
                                                    ? EdgeInsets.fromLTRB(
                                                        10, 50, 40, 0)
                                                    : EdgeInsets.fromLTRB(
                                                        40, 50, 10, 0),
                                                alignment: index % 2 == 0
                                                    ? Alignment.topRight
                                                    : Alignment.topLeft,
                                                child: Text(
                                                  "${snap[index].data['title']}",
                                                  //softWrap: true,
                                                  textAlign: index % 2 == 0
                                                      ? TextAlign.left
                                                      : TextAlign.right,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'Lexend Deca',
                                                      fontSize: 25),
                                                  //overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              child: Container(
                                                margin: index & 2 == 0
                                                    ? EdgeInsets.fromLTRB(
                                                        10, 5, 40, 0)
                                                    : EdgeInsets.fromLTRB(
                                                        40, 5, 10, 0),
                                                alignment: index % 2 == 0
                                                    ? Alignment.centerRight
                                                    : Alignment.centerLeft,
                                                child: Text(
                                                  "${snap[index].data['details']}",
                                                  softWrap: true,
                                                  textAlign: index % 2 == 0
                                                      ? TextAlign.left
                                                      : TextAlign.right,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'Lexend Deca',
                                                      fontSize: 15),
                                                  //overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //Card(
                            //   child: Container(
                            //     height:
                            //         MediaQuery.of(context).size.height * 0.2,
                            //     child: Center(
                            //       child: Text("${snap[index].data['title']}",
                            //           style: TextStyle(
                            //               fontFamily: 'Lexend Deca',
                            //               fontSize: 25)),
                            //     ),
                            //   ),
                            // ),
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
    floatingActionButton:Builder(
      builder: (context) {
        return FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){
            Navigator.push(
            context, MaterialPageRoute(builder: (BuildContext context) => test()));
            
          },
          );
      }
    )
    );
