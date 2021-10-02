import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

ProductModel foodModelFromJson(String str) => ProductModel.fromDocument(json.decode(str));


class ProductModel {
  ProductModel({
    this.productId,
    this.vendorId,
    this.name,
    this.image,
    this.price,
    this.isFavorite,
    this.creationTime,
    this.updateTime,
  });

  String? productId;
  String? vendorId;
  String? name;
  String? image;
  int? price;
  bool? isFavorite;
  String? creationTime;
  String? updateTime;

   factory ProductModel.fromDocument(DocumentSnapshot json) {
     var doc = json.data() as dynamic;
    return ProductModel(
      productId: doc["productId"],
      vendorId: doc["vendorId"],
      name: doc["name"],
      isFavorite: doc["isFavorite"],
      image: doc["image"],
      price: doc["price"],
     );
   }
  factory ProductModel.fromMap(Map<String, dynamic> json) {
    return ProductModel(
      productId: json["productId"],
      vendorId: json["vendorId"],
      name: json["name"],
      isFavorite: json["isFavorite"],
      image: json["image"],
      price: json["price"],
    );
  }
}
