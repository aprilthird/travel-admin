
import 'package:cloud_firestore/cloud_firestore.dart';

class Place {
  String state;
  String name;
  String place_name_sp;
  String location;
  double latitude;
  double longitude;
  String description;
  String descriptionSP;
  String imageUrl1;
  String imageUrl2;
  String imageUrl3;
  String imageUrl4;
  String gallery1;
  String gallery2;
  String gallery3;
  String gallery4;
  String gallery5;
  String gallery6;
  int loves;
  int commentsCount;
  String date;
  String timestamp;
  String category;
  String priceByApp;
  String priceByAppSP;
  String mobilePhone;
  String email;

  Place({
    this.state,
    this.name,
    this.place_name_sp,
    this.location,
    this.latitude,
    this.longitude,
    this.description,
    this.descriptionSP,
    this.imageUrl1,
    this.imageUrl2,
    this.imageUrl3,
    this.imageUrl4,
    this.gallery1,
    this.gallery2,
    this.gallery3,
    this.gallery4,
    this.gallery5,
    this.gallery6,
    this.loves,
    this.commentsCount,
    this.date,
    this.timestamp,
    this.category,
    this.priceByApp,
    this.priceByAppSP,
    this.mobilePhone,
    this.email
  });


  factory Place.fromFirestore(DocumentSnapshot snapshot){
    var d = snapshot;
    return Place(
      state: d['state'],
      name: d['place name'],
      place_name_sp: d.data().toString().contains('place_name_sp') ? d['place_name_sp'] : '',
      location: d['location'],
      latitude: d['latitude'],
      longitude: d['longitude'],
      description: d['description'],
      descriptionSP:  d.data().toString().contains('descriptionSP') ? d['descriptionSP'] : '',
      imageUrl1: d['image-1'],
      imageUrl2: d['image-2'],
      imageUrl3: d['image-3'],
      imageUrl4: d.data().toString().contains('image-4') ? d['image-4'] : '',
      gallery1: d.data().toString().contains('gallery-1') ? d['gallery-1'] : '',
      gallery2: d.data().toString().contains('gallery-2') ? d['gallery-2'] : '',
      gallery3: d.data().toString().contains('gallery-3') ? d['gallery-3'] : '',
      gallery4: d.data().toString().contains('gallery-4') ? d['gallery-4'] : '',
      gallery5: d.data().toString().contains('gallery-5') ? d['gallery-5'] : '',
      gallery6: d.data().toString().contains('gallery-6') ? d['gallery-6'] : '',
      mobilePhone: d.data().toString().contains('mobilePhone') ? d['mobilePhone'] : '',
      email: d.data().toString().contains('email') ? d['email'] : '',
      loves: d['loves'],
      commentsCount: d['comments count'],
      date: d['date'],
      timestamp: d['timestamp'],
      category: d['category'],
      priceByApp: d['priceByApp'],
      priceByAppSP : d.data().toString().contains('priceByAppSP') ? d['priceByAppSP'] : ''

    );
  }
}