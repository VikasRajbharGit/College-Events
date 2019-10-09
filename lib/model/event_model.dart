import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
class Event{
  String title;
  String details;
  List files ;
  String author;
  String category;
  String timeStamp;
  String contact;
  String committee;

  Event(this.title,this.details,this.files,this.author,this.category,this.timeStamp,this.contact,this.committee);

  Event.fromSnapshot(DataSnapshot snapshot):
    title=snapshot.value['title'],
    details=snapshot.value['details'],
    files=snapshot.value['files'],
    author=snapshot.value['author'],
    category=snapshot.value['category'],
    timeStamp=snapshot.value['timeStamp'],
    contact=snapshot.value['contact'],
    committee=snapshot.value['committee'];
    
    

  toJson(){
    return{
      'title':title,
      'details':details,
      'files':files,
      'author':author,
      'audience':category,
      'timeStamp':timeStamp,
      'contact':contact,
      'committee':committee
    };
  }

}