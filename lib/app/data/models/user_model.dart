import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.uid,
    this.name,
    this.email,
    this.photoUrl,
    this.creationTime,
    this.lastSignTime,
    this.updateTime,
  });

  String? uid;
  String? name;
  String? email;
  String? photoUrl;
  String? creationTime;
  String? lastSignTime;
  String? updateTime;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    uid: json["uid"],
    name: json["name"],
    email: json["email"],
    photoUrl: json["photoUrl"],
    creationTime: json["creationTime"],
    lastSignTime: json["lastSignTime"],
    updateTime: json["updateTime"],
    // favorite: List<Favorite>.from(json["Favorite"].map((x) => Favorite.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "name": name,
    "email": email,
    "photoUrl": photoUrl,
    "creationTime": creationTime,
    "lastSignTime": lastSignTime,
    "updateTime": updateTime,
    // "Favorite": List<dynamic>.from(favorite!.map((x) => x.toJson())),
  };
}
