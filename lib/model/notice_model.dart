import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
class Notice{
  String title;
  String details;
  List files ;
  String author;
  List audience;
  String timeStamp;

  Notice(this.title,this.details,this.files,this.author,this.audience,this.timeStamp);

  Notice.fromSnapshot(DataSnapshot snapshot):
    title=snapshot.value['title'],
    details=snapshot.value['details'],
    files=snapshot.value['files'],
    author=snapshot.value['author'],
    audience=snapshot.value['audience'],
    timeStamp=snapshot.value['last_updated'];
    
    

  toJson(){
    return{
      'title':title,
      'details':details,
      'files':files,
      'author':author,
      'audience':audience,
      'timeStamp':timeStamp
    };
  }

}