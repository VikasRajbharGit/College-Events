import 'package:flutter/material.dart';
import 'base_tab.dart';

CustomTab notificationsTab = CustomTab(
    appBarTitle: 'Notices',
    appBarActions: [],
    body: Builder(
      builder: (BuildContext context) {
        return Center(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (_, index) {
              return Card(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: Center(
                    child: Text('Notice ${index + 1}',
                        style:
                            TextStyle(fontFamily: 'Lexend Deca', fontSize: 25)),
                  ),
                ),
              );
            },
          ),
        );
      },
    ),
    floatingActionButton: null);
