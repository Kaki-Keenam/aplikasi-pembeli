import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

VendorModel userModelFromJson(String str) => VendorModel.fromDocument(json.decode(str));

class VendorModel {
  VendorModel({
    this.uid,
    this.storeName,
    this.email,
    this.image,
    this.street,
    this.status,
    this.rating,
  });

  String? uid;
  String? storeName;
  String? street;
  String? email;
  String? image;
  String? status;
  int? rating;

  factory VendorModel.fromDocument(DocumentSnapshot json) {
    var doc = json.data() as dynamic;
    return VendorModel(
      uid: doc["uid"],
      storeName: doc["storeName"],
      email: doc["email"],
      street: doc["lastLocation"],
      image: doc["storeImage"],
      status: doc["status"],
      rating: doc["rating"],
    );
  }
}
