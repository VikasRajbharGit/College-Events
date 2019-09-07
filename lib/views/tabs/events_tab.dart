import 'package:flutter/material.dart';
import 'base_tab.dart';
import '../detail_view.dart';

CustomTab eventsTab = CustomTab(
    appBarTitle: 'Events',
    appBarActions: [],
    body: Builder(
      builder: (BuildContext context) {
        return Center(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (_, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsView({'title': index}),
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
                      child: Column(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        child: Image.asset(
                          'assets/images/valley.jpg',

                          // width: MediaQuery.of(context).size.width*0.8 ,
                          // height: MediaQuery.of(context).size.height * 0.01,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      Center(
                        child: Text(
                          'Event ${index + 1}',
                          style: TextStyle(fontSize: 30),
                        ),
                      )
                    ],
                  )),
                ),
              );
            },
          ),
        );
      },
    ),
    floatingActionButton: null);
