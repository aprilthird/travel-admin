
import 'package:cloud_firestore/cloud_firestore.dart';

class Category {

  String name;
  String timestamp;
  String imageUrl;
  String imageBG;
  String date;

  Category({
    this.name,
    this.timestamp,
    this.imageUrl,
    this.imageBG,
    this.date
  });


  factory Category.fromFirestore(DocumentSnapshot snapshot){
    var d = snapshot;
    return Category(
        name: d['name'],
        timestamp: d['timestamp'],
        imageUrl: d['image'],
        imageBG: d['imageBG'],
        date: d['date']
    );
  }
}