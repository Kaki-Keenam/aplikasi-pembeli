import 'dart:convert';
import 'dart:ffi';

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
  int? totalPrice;
  int? quantity;
  double? rating;
  String? state;
  List<ProductModel>? product;

   factory TransactionModel.fromDocument(Map<String, dynamic> doc) {
    return TransactionModel(
        buyerId: doc["buyerId"],
        buyerLoc: doc["buyerLoc"],
        buyerName: doc["buyerName"],
        totalPrice: doc["totalPrice"],
        quantity: doc["quantity"],
        transactionId: doc["transactionId"],
        vendorId: doc["vendorId"],
        storeImage: doc["storeImage"],
        storeName: doc["storeName"],
        orderDate: doc["orderDate"],
        rating: doc["rating"].toDouble(),
        state: doc["state"],
      product: List<ProductModel>.from(doc["products"]?.map((x) => ProductModel.fromMap(x))),
     );
   }
}
