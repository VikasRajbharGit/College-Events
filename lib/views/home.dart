//import 'package:college_events/util/text_styles.dart' as prefix0;
import 'package:college_events/views/tabs/bookmarks_tab.dart';
import 'package:college_events/views/tabs/events_tab.dart';
import 'package:college_events/views/tabs/expired_notices.dart';
import 'package:college_events/views/tabs/notifications_tab.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

class _homeState extends State<home>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController;
  List<CustomTab> tabs = [eventsTab, notificationsTab, bookmarksTab];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  AnimationController _controller;
  Animation<double> animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage:------> $message");
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: ListTile(
                    title: Text('New Notice'),
                    subtitle: Text(message['notification']['title'])),
                // Image.asset(
                //   'assets/images/done.gif',
                //   //filterQuality: FilterQuality.low,
                // ),
                actions: <Widget>[
                  FlatButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })
                ],
              );
            });
        //_showItemDialog(message);
      },
      //onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch:----> $message");
        //_navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume:-----> $message");
        //_navigateToItemDetail(message);
      },
    );

    _controller =
        AnimationController(duration: Duration(milliseconds: 900), vsync: this);
    _tabController = TabController(length: tabs.length, vsync: this);

    animation = Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(
        curve: Curves.fastLinearToSlowEaseIn, parent: _controller));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    notificationsTab.context=context;
    notificationsTab.appBarActions=[IconButton(icon: Icon(Icons.history), onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>expired_notices()));
      })];
    return ScopedModelDescendant<FirebaseHandler>(
      builder: (context, child, model) {
        model.getprofile(false);
        model.getTheme(context);
        model.getUser();
        

        //model.getBookmark();
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  // var bs=BottomSheet(
  //   animationController: _controller,
  // );
}
