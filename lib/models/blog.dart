
import 'package:cloud_firestore/cloud_firestore.dart';

class Blog {

  String title;
  String titleSP;
  String description;
  String descriptionSP;
  String thumbnailImagelUrl;
  int loves;
  String sourceUrl;
  String date;
  String timestamp;

  Blog({

    this.title,
    this.titleSP,
    this.description,
    this.descriptionSP,
    this.thumbnailImagelUrl,
    this.loves,
    this.sourceUrl,
    this.date,
    this.timestamp
    
  });


  factory Blog.fromFirestore(DocumentSnapshot snapshot){
    var d = snapshot;
    return Blog(
      title: d['title'],
      titleSP: d.data().toString().contains('titleSP') ? d['titleSP'] : '',
      description: d['description'],
      descriptionSP:  d.data().toString().contains('descriptionSP') ? d['descriptionSP'] : '',
      thumbnailImagelUrl: d['image url'],
      loves: d['loves'],
      sourceUrl: d['source'],
      date: d['date'],
      timestamp: d['timestamp'], 


    );
  }
}