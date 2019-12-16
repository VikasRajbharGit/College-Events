import 'dart:io';
import 'package:college_events/views/registeration.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  Map<String, String> fToUp = {};
  File eventImage;
  var imgUrls = new List();
  Map noticeMap = {};
  var tempList = [];
  var bookmarks = [];
  var authority;
  var profile;
  notifyListeners();

  bookMark(data, type) {
    data.addAll({'type': type});
    db
        .collection('users')
        .document(currentUser.uid)
        .collection('bookmarks')
        .document(data['title'])
        .setData(data);
  }

  delBookMark(title) {
    db
        .collection('users')
        .document(currentUser.uid)
        .collection('bookmarks')
        .document(title)
        .delete();
  }

  Future<String> getImg(event, ext) async {
    var ref = await storageReference
        .child(
            'event-${event['title']}-${event['author']}-${event['timeStamp']}-1-$ext')
        .getDownloadURL();
    notifyListeners();
    print(ref);
    return ref;
  }

  void handleSubmit(GlobalKey<FormState> formkey, var Data, var branch) async {
    final FormState form = formkey.currentState;

    if (form.validate()) {
      form.save();
      var cuser = await _auth.currentUser();
      var uid = cuser.uid;

      await db.collection(branch).document(Data.title).setData(Data.toJson());

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

  uploadToStorage(context, key, Map<String, String> filePaths, name) async {
    List result = [];
    print(filePaths);
    try {
      var i = 1;
      filePaths.forEach((fileName, filePath) async {
        final StorageUploadTask uploadTask =
            storageReference.child('$name-$i${p.extension(filePath)}').putFile(
                  File(filePath),
                );

        // uploadTask.onComplete.then((onValue){
        //   return onValue.ref.getDownloadURL();
        // });

        i++;
        //final StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
        //notifyListeners();
      });
      final snackBar = SnackBar(
        content: Text('Image(s) uploaded'),
        duration: Duration(seconds: 3),
      );
      notifyListeners();

      //return taskSnapshot.ref.getDownloadURL();
      //print('---------->> $url');

      //notifyListeners();
      print('-------<<<<<<<$result');

      print('xxx------xxx $imgUrls');
      return imgUrls;
    } catch (e) {
      print(e);
    }
  }

  getUser() async {
    try {
      currentUser = await _auth.currentUser();
      username = currentUser.displayName;
      ppic = currentUser.photoUrl;
      email = currentUser.email;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<FirebaseUser> gSignIn(BuildContext context) async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken);

    final FirebaseUser user = await _auth.signInWithCredential(credential);
    print('Signed In as ----> ${user.displayName}');
    var authority = 'user';
    db.enablePersistence(true);
    if (user != null) {
      currentUser = user;
      username = user.displayName;
      print('-------xxx ${user.uid}');
      var reg = await Firestore.instance
          .collection('users')
          .document(user.uid)
          .collection('info')
          .document('info')
          .get()
          .then((results) {
        print('=====' + results.data.toString());
        registered = results.exists;
        print(registered);
      });
      if (registered) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => home()),
        );
      } else {
        print('----->>$registered');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => register()),
        );
      }

      //var topics=[];
      if (registered) {
        var ref = db
            .collection('users')
            .document(currentUser.uid)
            .collection('info')
            .document('info')
            .get()
            .then((res) {
          //print(res.documents[0].data);
          var t = res.data;
          authority = t['authority'];
          var temp = t['subscriptions'];
          print(temp);

          // temp.forEach((val) {
          //   topics.add(val);
          // });
          saveDeviceToken(temp);
          //print(model.bookmarks);

          //print(model.bookmarks[0]);
        });
      }
      return user;
    }

    //return user;
  }

  gSignOut(BuildContext context) async {
    var ref = db
        .collection('users')
        .document(currentUser.uid)
        .collection('info')
        .document('info')
        .get()
        .then((res) async {
      //print(res.documents[0].data);
      var t = res.data;
      //authority = t[0].data['authority'];
      var temp = t['subscriptions'];
      print(temp);

      temp.forEach((val) {
        _fcm.unsubscribeFromTopic(val);
      });

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => login()));

      await FirebaseAuth.instance.signOut();
      await _googleSignIn.signOut();
      if (tm == ThemeMode.dark) {
        switchTheme(context);
      }
      //_fcm.unsubscribeFromTopic('notification');
      
      //saveDeviceToken(temp);
      //print(model.bookmarks);

      //print(model.bookmarks[0]);
    });
  }

  getTheme(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var t = true;
    try {
      t = await prefs.getBool('tm');
      if (t) {
        tm = ThemeMode.light;
      } else {
        tm = ThemeMode.dark;
      }
      notifyListeners();
      AppBuilder.of(context).rebuild();
    } catch (e) {
      print(e);
    }
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

  saveDeviceToken(List topics) async {
    // Get the token for this device
    String fcmToken = await _fcm.getToken();

    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = db
          .collection('users')
          .document(currentUser.uid)
          .collection('tokens')
          .document(fcmToken);
      topics.forEach((topic) {
        var f = _fcm.subscribeToTopic(topic);
        print('------------------>>>$f');
      });

      await tokens.setData({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(), // optional
        'platform': Platform.operatingSystem, // optional
        'topics': topics
      });
    }
  }
}
