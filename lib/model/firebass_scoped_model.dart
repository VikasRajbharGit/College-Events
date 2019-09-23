import 'dart:io';
import 'package:flutter/material.dart' as prefix0;
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:college_events/views/home.dart';
import 'package:college_events/views/login.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../app_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import '../model/notice_model.dart';

class FirebaseHandler extends Model {
  ThemeMode tm = ThemeMode.light;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = new GoogleSignIn();
  final db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final StorageReference storageReference = FirebaseStorage.instance.ref();
  FirebaseUser currentUser;
  var registered = false;
  var username = 'Username';
  String ppic;
  var email = '';
  var fToUp;
  var imgUrls = new List();
  Map noticeMap = {};
  notifyListeners();

  void handleSubmit(GlobalKey<FormState> formkey, Notice noticeData) async {
    final FormState form = formkey.currentState;
    if (form.validate()) {
      form.save();
      var cuser = await _auth.currentUser();
      var uid = cuser.uid;
      //print('---------->$cuser');

      //DocumentReference ref=await db.collection(uid).add(todo.toJson());
      //await db.collection('users').document('registered').collection(uid).add(u.toJson());
      await db
          .collection('notices')
          .document(noticeData.title)
          .setData(noticeData.toJson());

      //await db.collection('user').add(u.toJson());
      //form.reset();

      //databaseReference.push().set(todo.toJson());
    }
  }

  stageNoticeFiles(fileType) async {
    Map<String, String> filePaths =
        await FilePicker.getMultiFilePath(type: fileType);
    print('--------------$filePaths');
    fToUp = filePaths;
    notifyListeners();
    return filePaths;
  }

  uploadToStorage(context, key, filePaths) async {
    // Map<String, String> filePaths;
    // if (type == 'image') {
    //   filePaths = await FilePicker.getMultiFilePath(type: FileType.IMAGE);
    // } else {
    //   filePaths = await FilePicker.getMultiFilePath(fileExtension: 'pdf');
    // }
    List result = [];
    print(filePaths);
    try {
      filePaths.forEach((fileName, filePath) async {
        final StorageUploadTask uploadTask =
            storageReference.child(fileName).putFile(
                  File(filePath),
                  // StorageMetadata(
                  //   contentType: type + '/' + p.extension(filePath),
                  // ),
                );
        final StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
        final String url = await taskSnapshot.ref.getDownloadURL();
        print('---------->> $url');
        imgUrls.add(url);
        notifyListeners();
        print('-------<<<<<<<$result');
        notifyListeners();
        final snackBar = SnackBar(
          content: Text('Image(s) uploaded'),
          duration: Duration(seconds: 3),
        );
        //key.currentState.showSnackBar(snackBar);
      });
      return result;
    } catch (e) {
      print('Error');
    }
  }

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
    if (tm == ThemeMode.dark) {
      switchTheme(context);
    }
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext context) => login()));
  }

  getTheme(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //var t = true;
    var t = await prefs.getBool('tm');
    if (t) {
      tm = ThemeMode.light;
    } else {
      tm = ThemeMode.dark;
    }
    notifyListeners();
    AppBuilder.of(context).rebuild();
  }

  switchTheme(context) async {
    if (tm == ThemeMode.light) {
      tm = ThemeMode.dark;
    } else {
      tm = ThemeMode.light;
    }
    notifyListeners();
    bool t = (tm == ThemeMode.light);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tm', t);
    AppBuilder.of(context).rebuild();
  }

  saveDeviceToken() async {
    // Get the token for this device
    String fcmToken = await _fcm.getToken();

    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = db
          .collection('users')
          .document(currentUser.uid)
          .collection('tokens')
          .document(fcmToken);
      var f = _fcm.subscribeToTopic('notification');
      print('------------------>>>$f');
      await tokens.setData({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(), // optional
        'platform': Platform.operatingSystem // optional
      });
    }
  }
}
