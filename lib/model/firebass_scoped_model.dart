import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:college_events/views/home.dart';
import 'package:college_events/views/login.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseHandler extends Model {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = new GoogleSignIn();
  final db = Firestore.instance;
  final FirebaseMessaging _fcm=FirebaseMessaging();
  FirebaseUser currentUser;
  var registered = false;
  var username = 'Username';
  String ppic;
  var email = '';
  notifyListeners();

  getUser() async {
    currentUser = await _auth.currentUser();
    username = currentUser.displayName;
    ppic = currentUser.photoUrl;
    email = currentUser.email;
    notifyListeners();

    //return Text('${cuser.displayName}');
  }

  gSignIn(BuildContext context) async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken);

    final FirebaseUser user = await _auth.signInWithCredential(credential);
    print('Signed In as ----> ${user.displayName}');
    db.enablePersistence(true);
    if (user != null) {
      currentUser = user;
      username = user.displayName;
      notifyListeners();
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => home()),
    );

    //return user;
  }

  gSignOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext context) => login()));
  }

   saveDeviceToken() async {

    // Get the current user
    //String uid = 'jeffd23';
    // FirebaseUser user = await _auth.currentUser();

    // Get the token for this device
    String fcmToken = await _fcm.getToken();

    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = db
          .collection('users')
          .document(currentUser.uid)
          .collection('tokens')
          .document(fcmToken);

      await tokens.setData({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(), // optional
        'platform': Platform.operatingSystem // optional
      });
      _fcm.subscribeToTopic('notification');
    }
  }
}
