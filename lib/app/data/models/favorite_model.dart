
class FavoriteModel {
  List<Favorite>? favorite;

  FavoriteModel({
    this.favorite,
  });
}

class Favorite {
  Favorite({
    this.id,
    this.title,
    this.rating,
    this.image,
    this.vendor,
    this.lastTime,
    this.isFavorite,
  });

  String? id;
  String? title;
  String? rating;
  String? image;
  String? vendor;
  bool? isFavorite;
  String? lastTime;

  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
    id: json["id"],
    title: json["title"],
    rating: json["rating"],
    image: json["image"],
    vendor: json["vendor"],
    lastTime: json["lastTime"],
    isFavorite: json["isFavorite"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "rating": rating,
    "image": image,
    "vendor": vendor,
    "lastTime": lastTime,
    "isFavorite": isFavorite,
  };
}