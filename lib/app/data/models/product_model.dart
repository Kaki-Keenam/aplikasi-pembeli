import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

ProductModel foodModelFromJson(String str) => ProductModel.fromDocument(json.decode(str));


class ProductModel {
  ProductModel({
    this.productId,
    this.vendorId,
    this.name,
    this.vendorName,
    this.image,
    this.distance,
    this.price,
    this.quantity,
    this.isFavorite,
    this.creationTime,
    this.updateTime,
  });

  String? productId;
  String? vendorId;
  String? name;
  String? vendorName;
  String? image;
  double? distance;
  int? price;
  int? quantity;
  bool? isFavorite;
  String? creationTime;
  String? updateTime;

   factory ProductModel.fromDocument(DocumentSnapshot json) {
     var doc = json.data() as dynamic;
    return ProductModel(
      productId: doc["productId"],
      vendorId: doc["vendorId"],
      name: doc["name"],
      vendorName: doc["vendorName"],
      isFavorite: doc["isFavorite"],
      image: doc["image"],
      quantity: doc["quantity"],
      price: doc["price"],
     );
   }
  factory ProductModel.fromMap(Map<String, dynamic> json) {
    return ProductModel(
      productId: json["productId"],
      vendorId: json["vendorId"],
      name: json["name"],
      vendorName: json["vendorName"],
      isFavorite: json["isFavorite"],
      image: json["image"],
      quantity: json["quantity"],
      price: json["price"],
    );
  }
}
