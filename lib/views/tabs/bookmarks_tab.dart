import 'package:flutter/material.dart';
import '../detail_view.dart';
import 'base_tab.dart';

CustomTab bookmarksTab = CustomTab(
    appBarTitle: 'Bookmarks',
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
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: Center(
                      child: Text(
                        'Bookmark ${index + 1}',
                        style:
                            TextStyle(fontFamily: 'Lexend Deca', fontSize: 25),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    ),
    floatingActionButton: null);
