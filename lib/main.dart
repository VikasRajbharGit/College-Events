import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_events/model/firebass_scoped_model.dart';
import 'package:college_events/views/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'views/login.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  FirebaseAuth _auth;
  _auth = FirebaseAuth.instance;
  final db = Firestore.instance;

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
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // appBarTheme: AppBarTheme(color: Colors.grey[900]),
          // canvasColor: Colors.black,
          fontFamily: 'Lexend Deca',
          primarySwatch: Colors.red,
          //cardColor: Colors.grey[900]
          
          
        ),
        home: !loggedIn
            ? login()
            : (!registered
                ? home()
                : login()), //login()//MyHomePage(title: 'Flutter Demo Home Page'),
      ),
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
