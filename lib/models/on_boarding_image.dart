import 'package:cloud_firestore/cloud_firestore.dart';

class OnBoardingImage {
  String imageUrl;
  String timestamp;
  String date;

  OnBoardingImage({
    this.imageUrl,
    this.date,
    this.timestamp,
  });

  factory OnBoardingImage.fromFirestore(DocumentSnapshot snapshot) {
    var d = snapshot;
    return OnBoardingImage(
      imageUrl: d['url'],
      date: d['date'],
      timestamp: d['timestamp'],
    );
  }
}
