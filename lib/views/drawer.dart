import 'package:flutter/material.dart';
import 'package:college_events/model/firebass_scoped_model.dart';
import 'home.dart';
import 'package:scoped_model/scoped_model.dart';

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
        model.getUser();
        return Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    //SizedBox(height: 2,),
                    CircleAvatar(
                      //child: smodel.ppic==null ? Icon(Icons.person):Image.network(smodel.ppic,),
                      backgroundImage: model.ppic == null
                          ? AssetImage('assets/images/anim.gif')
                          : NetworkImage(model.ppic),
                      //backgroundImage: AssetImage('assets/images/u.png'),
                      radius: 40,
                    ),
                    Spacer(),
                    Text(model.username),
                    Spacer(),
                    Text(model.email)
                  ],
                ), //Text('${smodel.uname}'),
                decoration: BoxDecoration(
                  color: Colors.blue[400],
                ),
              ),
              ListTile(
                title: Text('Home'),
                selected: active == 1 ? true : false,
                onTap: () {
                  model.getUser();
                  //model.notifyListeners();
                  Navigator.pop(context);
                  if (active != 1) {
                    Navigator.pop(context);
                    Navigator.push(
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
                title: Text('log out'),
                //selected: active==2 ? true:false,
                onTap: () {
                  Navigator.pop(context);
                  if (active != 2) {
                    model.gSignOut(context);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
