import 'package:college_events/util/text_styles.dart' as prefix0;
import 'package:college_events/views/tabs/bookmarks_tab.dart';
import 'package:college_events/views/tabs/events_tab.dart';
import 'package:college_events/views/tabs/notifications_tab.dart';
import 'package:flutter/material.dart';
import 'package:college_events/model/firebass_scoped_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:college_events/util/text_styles.dart';
import 'drawer.dart';
import 'tabs/base_tab.dart';

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<CustomTab> tabs = [eventsTab, notificationsTab, bookmarksTab];

  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(length: tabs.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<FirebaseHandler>(
      builder: (context, child, model) {
        return Scaffold(
          appBar: AppBar(
            elevation: 20,
            title: Text(tabs[_tabController.index].appBarTitle,
                style: TextStyle(fontFamily: 'Lexend Deca')),
            actions: tabs[_tabController.index].appBarActions,
          ),
          body: TabBarView(
            controller: _tabController,
            children: <Widget>[
              eventsTab.body,
              notificationsTab.body,
              bookmarksTab.body
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _tabController.index,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.event),
                  title: Text(
                    'Events',
                    style: TextStyle(fontFamily: 'Lexend Deca'),
                  )),
              BottomNavigationBarItem(
                  icon: Icon(Icons.notifications),
                  title: Text(
                    'Notices',
                    style: TextStyle(fontFamily: 'Lexend Deca'),
                  )),
              BottomNavigationBarItem(
                  icon: Icon(Icons.bookmark),
                  title: Text(
                    'Bookmarks',
                    style: TextStyle(fontFamily: 'Lexend Deca'),
                  ))
            ],
            
            onTap: (int index) {
              setState(() {
                _tabController.index = index;
              });
            },
          ),
          drawer: NavigationDrawer(1, context),
          floatingActionButton: tabs[_tabController.index].floatingActionButton,
        );
      },
    );
  }
}
