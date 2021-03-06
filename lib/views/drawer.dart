import 'package:college_events/views/feedback.dart' as prefix0;
import 'package:college_events/views/rail_con.dart';
import 'package:flutter/material.dart';
import 'package:college_events/model/firebass_scoped_model.dart';
import 'home.dart';
import 'package:scoped_model/scoped_model.dart';
import 'profile.dart';
import 'feedback.dart';
import 'help.dart';

class NavigationDrawer extends StatefulWidget {
  int active;
  BuildContext context;
  NavigationDrawer(this.active, this.context);
  @override
  _NavigationDrawerState createState() =>
      _NavigationDrawerState(active, context);
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  int active;
  BuildContext context;
  _NavigationDrawerState(this.active, this.context);
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<FirebaseHandler>(
      builder: (context, child, model) {
        model.getprofile(true);
        return Opacity(
          opacity: 1,
          child: Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              //height: MediaQuery.of(context).size.height * 0.7,
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.only(bottomRight: Radius.circular(150))
              // ),
              child: ClipRRect(
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(20)),
                child: Drawer(
                  child: ListView(
                    children: <Widget>[
                      DrawerHeader(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            //SizedBox(height: 2,),
                            Row(
                              children: <Widget>[
                                CircleAvatar(
                                  //child: smodel.ppic==null ? Icon(Icons.person):Image.network(smodel.ppic,),
                                  backgroundImage: model.ppic == null
                                      ? AssetImage('assets/images/anim.gif')
                                      : NetworkImage(model.ppic),
                                  //backgroundImage: AssetImage('assets/images/u.png'),
                                  radius: 40,
                                ),
                                IconButton(
                                  icon: Icon(Icons.brightness_6),
                                  onPressed: () {
                                    model.switchTheme(context);
                                  },
                                )
                              ],
                            ),
                            Spacer(),
                            Text(model.username),
                            Spacer(),
                            Text(model.email),
                          ],
                        ), //Text('${smodel.uname}'),
                        decoration: BoxDecoration(
                          color: Color(0xffe0e0e0e0),
                        ),
                      ),
                      ListTile(
                        title: Row(
                          children: <Widget>[
                            Icon(Icons.home),
                            Padding(
                              padding: EdgeInsets.all(10),
                            ),
                            Text('Home')
                          ],
                        ),
                        selected: active == 1 ? true : false,
                        onTap: () {
                          //model.getUser();
                          //model.notifyListeners();
                          Navigator.pop(context);
                          if (active != 1) {
                            //Navigator.pop(context);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => home(),
                                ));
                          }
                          setState(() {
                            active = 1;
                          });
                        },
                      ),
                      ListTile(
                        title: Row(
                          children: <Widget>[
                            Icon(Icons.person),
                            Padding(
                              padding: EdgeInsets.all(10),
                            ),
                            Text('Profile')
                          ],
                        ),
                        selected: active == 2 ? true : false,
                        onTap: () {
                          //model.getUser();
                          //model.notifyListeners();
                          Navigator.pop(context);
                          if (active != 2) {
                            //Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Profile(),
                                ));
                          }
                          setState(() {
                            active = 2;
                          });
                        },
                      ),
                      ListTile(
                        title: Row(
                          children: <Widget>[
                            Icon(Icons.feedback),
                            Padding(
                              padding: EdgeInsets.all(10),
                            ),
                            Text('Feedback')
                          ],
                        ),
                        selected: active == 3 ? true : false,
                        onTap: () {
                          //model.getUser();
                          //model.notifyListeners();
                          Navigator.pop(context);
                          if (active != 3) {
                            //Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => prefix0.Feedback(),
                                ));
                          }
                          setState(() {
                            active = 3;
                          });
                        },
                      ),
                      ListTile(
                        title: Row(
                          children: <Widget>[
                            Icon(Icons.help),
                            Padding(
                              padding: EdgeInsets.all(10),
                            ),
                            Text('About')
                          ],
                        ),
                        selected: active == 4 ? true : false,
                        onTap: () {
                          //model.getUser();
                          //model.notifyListeners();
                          Navigator.pop(context);
                          if (active != 4) {
                            //Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => help(),
                                ));
                          }
                          setState(() {
                            active = 4;
                          });
                        },
                      ),
                      ListTile(
                        title: Row(
                          children: <Widget>[
                            Icon(Icons.directions_railway),
                            Padding(
                              padding: EdgeInsets.all(10),
                            ),
                            Text('Concession')
                          ],
                        ),
                        selected: active == 5 ? true : false,
                        onTap: () {
                          //model.getUser();
                          //model.notifyListeners();
                          Navigator.pop(context);
                          if (active != 5) {
                            //Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => concession(),
                                ));
                          }
                          setState(() {
                            active = 5;
                          });
                        },
                      ),
                      ListTile(
                        title: Row(
                          children: <Widget>[
                            Icon(Icons.arrow_back),
                            Padding(
                              padding: EdgeInsets.all(10),
                            ),
                            Text('Logout')
                          ],
                        ),
                        //selected: active==2 ? true:false,
                        onTap: () {
                          Navigator.pop(context);
                          if (active != 6) {
                            model.gSignOut(context);
                            setState(() {
                              active = 6;
                            });
                          }
                        },
                      ),
                      
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
