import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../detail_view.dart';
import 'base_tab.dart';
import 'package:college_events/model/firebass_scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

CustomTab notificationsTab = CustomTab(
    appBarTitle: 'Notices',
    appBarActions: [],
    body: Builder(
      builder: (BuildContext context) {
        return ScopedModelDescendant<FirebaseHandler>(
          builder: (context, child, model) {
            return Center(
              child: StreamBuilder<QuerySnapshot>(
                  stream: model.db.collection('notices').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var snap=snapshot.data.documents.asMap();
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
                            child: Card(
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                child: Center(
                                  child: Text("${snap[index].data['title']}",
                                      style: TextStyle(
                                          fontFamily: 'Lexend Deca',
                                          fontSize: 25)),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                    else{
                      return Center(child:Image.asset('assets/images/simba.gif'));
                    }

                  }),
            );
          },
        );
      },
    ),
    floatingActionButton: null);
