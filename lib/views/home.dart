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
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


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
        model.getTheme(context);
        model.getUser();
        var height=MediaQuery.of(context).size.height;
        return Scaffold(
          key: _scaffoldKey,
          // appBar: AppBar(
          //   elevation: 20,
          //   title: Text(tabs[_tabController.index].appBarTitle,
          //       style: TextStyle(fontFamily: 'Lexend Deca')),
          //   actions: tabs[_tabController.index].appBarActions,
          // leading: GestureDetector(
          //     child: Text(tabs[_tabController.index].appBarTitle,
          //       style: TextStyle(fontFamily: 'Lexend Deca')),
          //       onTap: (){_scaffoldKey.currentState.openDrawer();},
          //   ),
          // ),
          body: Stack(
            children: <Widget>[
              Container(
                              child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    eventsTab.body,
                    notificationsTab.body,
                    bookmarksTab.body
                  ],
                ),
              ),
              GestureDetector(
                onTap: (){_scaffoldKey.currentState.openDrawer();},
                              child: Container(
                  height: height*0.12,//MediaQuery.of(context).size.height*0.15,
                  width: height*0.1,//MediaQuery.of(context).size.height*0.15,//width*0.3,
                  decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomRight: Radius.circular(height*0.15)),
                  color: Colors.red),
                  child: Align(alignment:Alignment.center,child: Icon(Icons.menu,size: height*0.05,color: Colors.white,),),
                ),
              ),
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
