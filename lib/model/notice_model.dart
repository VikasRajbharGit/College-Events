import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
class Notice{
  String name;
  String title;
  String details;
  List files ;
  String author;
  List audience;
  String timeStamp;
  String priority;
  String deadline;

  Notice(this.title,this.details,this.files,this.author,this.audience,this.timeStamp,this.priority,this.deadline);

  Notice.fromSnapshot(DataSnapshot snapshot):
    name=snapshot.value['name'],
    title=snapshot.value['title'],
    details=snapshot.value['details'],
    files=snapshot.value['files'],
    author=snapshot.value['author'],
    audience=snapshot.value['audience'],
    timeStamp=snapshot.value['last_updated'],
    priority=snapshot.value['priority'],
    deadline=snapshot.value['deadline'];
    
    

  toJson(){
    return{
      'name':name,
      'title':title,
      'details':details,
      'files':files,
      'author':author,
      'audience':audience,
      'timeStamp':timeStamp,
      'priority':priority,
      'deadline':deadline,
    };
  }

}