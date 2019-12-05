//import 'package:college_events/util/text_styles.dart' as prefix0;
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

class _homeState extends State<home> with TickerProviderStateMixin {
  TabController _tabController;
  List<CustomTab> tabs = [eventsTab, notificationsTab, bookmarksTab];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  AnimationController _controller;
  Animation<double> animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller =
        AnimationController(duration: Duration(milliseconds: 900), vsync: this);
    _tabController = TabController(length: tabs.length, vsync: this);

    animation = Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(
        curve: Curves.fastLinearToSlowEaseIn, parent: _controller));
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return ScopedModelDescendant<FirebaseHandler>(
      builder: (context, child, model) {
        model.getTheme(context);
        model.getUser();
        getBookmark() async {
          var ref = await model.db
              .collection('users')
              .document(model.currentUser.uid)
              .collection('bookmarks')
              .snapshots()
              .listen((res) {
            //print(res.documents[0].data);
            var t = res.documents.asMap();
            model.bookmarks.removeRange(0, model.bookmarks.length);
            t.forEach((key, val) {
              model.bookmarks.add(val.data['title']);
            });
            //print(model.bookmarks);

            //print(model.bookmarks[0]);
          });

          //print(model.bookmarks.length);
        }

        //getBookmark();
        var height = MediaQuery.of(context).size.height;
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                //elevation: 0,
                title: Text(tabs[_tabController.index].appBarTitle,
                    style: TextStyle(fontFamily: 'Lexend Deca')),
                actions: tabs[_tabController.index].appBarActions,
              ),
              body: Stack(
                children: <Widget>[
                  Transform(
                    transform: Matrix4.translationValues(
                        0, animation.value * height, 0),
                    child: Container(
                      child: TabBarView(
                        controller: _tabController,
                        children: <Widget>[
                          eventsTab.body,
                          notificationsTab.body,
                          bookmarksTab.body
                        ],
                      ),
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
              floatingActionButton:
                  tabs[_tabController.index].floatingActionButton,
            );
          },
        );
      },
    );
  }

  // var bs=BottomSheet(
  //   animationController: _controller,
  // );
}
