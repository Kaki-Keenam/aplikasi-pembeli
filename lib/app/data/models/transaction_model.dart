import 'dart:convert';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kakikeenam/app/data/models/product_model.dart';

TransactionModel foodModelFromJson(String str) => TransactionModel.fromDocument(json.decode(str));


class TransactionModel {
  TransactionModel({
    this.buyerId,
    this.transactionId,
    this.vendorId,
    this.storeImage,
    this.orderDate,
    this.storeName,
    this.buyerLoc,
    this.buyerName,
    this.rating,
    this.state,
    this.isRated,
    this.address,
    this.totalPrice,
    this.quantity,
    this.product,
  });
  String? buyerId;
  String? transactionId;
  String? vendorId;
  String? storeImage;
  String? storeName;
  String? orderDate;
  GeoPoint? buyerLoc;
  String? buyerName;
  String? address;
  int? totalPrice;
  int? quantity;
  bool? isRated;
  double? rating;
  String? state;
  List<ProductModel>? product;

   factory TransactionModel.fromDocument(Map<String, dynamic> json) {
    return TransactionModel(
        buyerId: json["buyerId"],
        buyerLoc: json["buyerLoc"],
        buyerName: json["buyerName"],
        totalPrice: json["totalPrice"],
        quantity: json["quantity"],
        transactionId: json["transactionId"],
        vendorId: json["vendorId"],
        storeImage: json["storeImage"],
        storeName: json["storeName"],
        orderDate: json["orderDate"],
        isRated: json["isRated"],
        rating: json["rating"].toDouble(),
        state: json["state"],
      product: List<ProductModel>.from(json["products"]?.map((x) => ProductModel.fromMap(x))),
     );
   }
}
