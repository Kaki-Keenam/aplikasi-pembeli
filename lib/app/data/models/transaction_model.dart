import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kakikeenam/app/data/models/product_model.dart';

TransactionModel foodModelFromJson(String str) => TransactionModel.fromDocument(json.decode(str));


class TransactionModel {
  TransactionModel({
    this.buyerId,
    this.transactionId,
    this.vendorId,
    this.image,
    this.orderDate,
    this.storeName,
    this.rating,
    this.state,
    this.product,
  });
  String? buyerId;
  String? transactionId;
  String? vendorId;
  String? image;
  String? storeName;
  String? orderDate;
  int? rating;
  String? state;
  List<ProductModel>? product;

   factory TransactionModel.fromDocument(DocumentSnapshot json) {
     var doc = json.data() as dynamic;
    return TransactionModel(
        buyerId: doc["buyerId"],
        transactionId: doc["transactionId"],
        vendorId: doc["vendorId"],
        image: doc["storeImage"],
        storeName: doc["storeName"],
        orderDate: doc["orderDate"],
        rating: doc["rating"],
        state: doc["state"],
     );
   }
}
