import 'dart:convert';

ReviewModel reviewModelFromJson(String str) => ReviewModel.fromJson(json.decode(str));

String reviewModelToJson(ReviewModel data) => json.encode(data.toJson());

class ReviewModel {
  ReviewModel({
    this.results,
  });

  List<Review>? results;

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
    results: List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "reviews": List<dynamic>.from(results!.map((x) => x.toJson())),
  };
}

class Review {
  Review({
    this.vendorId,
    this.buyerId,
    this.rating,
    this.buyerName,
  });

  String? vendorId;
  String? buyerId;
  String? buyerName;
  double? rating;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    vendorId: json["vendorId"],
    buyerId: json["buyerId"],
    buyerName: json["buyerName"],
    rating: json["rating"],
  );

  Map<String, dynamic> toJson() => {
    "vendorId": vendorId,
    "buyerId": buyerId,
    "rating": rating,
  };
}