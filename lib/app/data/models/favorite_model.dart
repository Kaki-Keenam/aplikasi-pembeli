
class FavoriteModel {
  List<Favorite>? favorite;

  FavoriteModel({
    this.favorite,
  });
}

class Favorite {
  Favorite({
    this.productId,
    this.name,
    this.rating,
    this.image,
    this.price,
    this.vendor,
    this.vendorId,
    this.lastTime,
    this.isFavorite,
  });

  String? productId;
  String? name;
  String? rating;
  String? image;
  String? price;
  String? vendorId;
  String? vendor;
  bool? isFavorite;
  String? lastTime;

  factory Favorite.fromDocument(Map<String, dynamic> json) => Favorite(
    productId: json["productId"],
    name: json["name"],
    image: json["image"],
    price: json["price"].toString(),
    vendorId: json["vendorId"],
    vendor: json["vendor"],
    lastTime: json["lastTime"],
    isFavorite: json["isFavorite"],
  );

  // Map<String, dynamic> toJson() => {
  //   "id": id,
  //   "title": name,
  //   "rating": rating,
  //   "image": imageUrl,
  //   "vendor": vendor,
  //   "lastTime": lastTime,
  //   "isFavorite": isFavorite,
  // };
}