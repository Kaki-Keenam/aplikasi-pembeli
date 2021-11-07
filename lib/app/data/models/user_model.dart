import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

UserModel userModelFromJson(String str) => UserModel.fromDocument(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.uid,
    this.name,
    this.email,
    this.photoUrl,
    this.lastLocation,
    this.creationTime,
    this.lastSignTime,
    this.updateTime,
  });

  String? uid;
  String? name;
  String? email;
  String? photoUrl;
  String? creationTime;
  GeoPoint? lastLocation;
  String? lastSignTime;
  String? updateTime;

  factory UserModel.fromDocument(Map<String, dynamic> json) => UserModel(
    uid: json["uid"],
    name: json["name"],
    email: json["email"],
    photoUrl: json["photoUrl"],
    lastLocation: json["lastLocation"],
    creationTime: json["creationTime"],
    lastSignTime: json["lastSignTime"],
    updateTime: json["updateTime"],
  );

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "name": name,
    "email": email,
    "photoUrl": photoUrl,
    "creationTime": creationTime,
    "lastSignTime": lastSignTime,
    "updateTime": updateTime,
  };
}
