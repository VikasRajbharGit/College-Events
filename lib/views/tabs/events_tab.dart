import 'package:flutter/material.dart';
import 'base_tab.dart';

CustomTab eventsTab = CustomTab(
    appBarTitle: 'Events',
    appBarActions: [],
    body: Builder(
      builder: (BuildContext context) {
        return Center(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (_, index) {
              return Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Image.asset(
                            'assets/images/valley.jpg',
                            // width: MediaQuery.of(context).size.width ,
                            // height: MediaQuery.of(context).size.height * 0.18,
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
              );
            },
          ),
        );
      },
    ),
    floatingActionButton: null);
