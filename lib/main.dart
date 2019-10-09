import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_events/model/firebass_scoped_model.dart';
import 'package:college_events/views/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'views/login.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'app_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool t=true;
void main() async {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  FirebaseAuth _auth;
  _auth = FirebaseAuth.instance;
  final db = Firestore.instance;
   var prefs = await SharedPreferences.getInstance();
   t= await prefs.getBool('tm');

  bool loggedIn = false;
  bool registered = false;
  FirebaseUser mcurrentUser;
  mcurrentUser = await _auth.currentUser();
  if (mcurrentUser != null) {
    loggedIn = true;
    // var ref = await Firestore.instance
    //     .collection('users')
    //     .document(mcurrentUser.uid)
    //     .get()
    //     .then((results) {
    //   registered = results.exists;
    // });
  }
  fcmHandler();
  runApp(MyApp(loggedIn, registered));
}

class MyApp extends StatelessWidget {
  final FirebaseMessaging _firebaseMessaging= FirebaseMessaging();

  bool loggedIn;
  bool registered;
  final FirebaseHandler _model = new FirebaseHandler();
  
  MyApp(this.loggedIn, this.registered);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: _model,
      child: AppBuilder(
        builder: (context){
          // _model.getTheme(context);
          return MaterialApp(
        darkTheme: ThemeData(canvasColor: Colors.black,brightness: Brightness.dark),
        themeMode: _model.tm,
        title: 'Flutter Demo',
        theme: ThemeData(
          // appBarTheme: AppBarTheme(color: Colors.grey[900]),
          canvasColor: Color(0xffeeeeee),
          appBarTheme: AppBarTheme(color:Color(0xffeeeeee),elevation: 0,textTheme: TextTheme(title: TextStyle(color:Colors.black,fontSize: 30,fontFamily: 'Lexend Deca',fontWeight: FontWeight.w700)),
          iconTheme:IconThemeData(color: Colors.black)  ),
          fontFamily: 'Lexend Deca',
          primarySwatch: Colors.red,
          //cardColor: Colors.grey[900]
          
          
        ),
        home: !loggedIn
            ? login()
            : (!registered
                ? home()
                : login()), //login()//MyHomePage(title: 'Flutter Demo Home Page'),
      );
        },
      )
    );

  }
}

fcmHandler() async{
  final FirebaseMessaging _firebaseMessaging= FirebaseMessaging();
   _firebaseMessaging.configure(
       onMessage: (Map<String, dynamic> message) async {
         print("onMessage:------> $message");
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
}
