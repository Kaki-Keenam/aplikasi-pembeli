import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

VendorModel userModelFromJson(String str) => VendorModel.fromDocument(json.decode(str));

class VendorModel {
  VendorModel({
    this.uid,
    this.storeName,
    this.email,
    this.storeImage,
    this.street,
    this.distance,
    this.location,
    this.status,
    this.district,
    this.rating,

  });

  String? uid;
  String? storeName;
  String? street;
  GeoPoint? location;
  double? distance;
  String? email;
  String? district;
  String? storeImage;
  String? status;
  double? rating;

  factory VendorModel.fromDocument(DocumentSnapshot json) {
    var doc = json.data() as dynamic;
    return VendorModel(
      uid: doc["uid"],
      storeName: doc["storeName"],
      email: doc["email"],
      district: doc["district"],
      location: doc["lastLocation"],
      storeImage: doc["storeImage"],
      status: doc["status"],
      rating: doc["rating"].toDouble(),
    );
  }
}
