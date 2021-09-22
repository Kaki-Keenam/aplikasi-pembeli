class FoodModel {
  int? id;
  String? title;
  int? rating;
  String? image;
  String? vendor;

  FoodModel(this.title, this.rating, this.image, this.vendor, this.id);
}

List<FoodModel> nearFoods = nearFoodData
    .map((item) =>
    FoodModel(item['title'] as String?, item['rating'] as int?, item['image'] as String?, item['vendor'] as String?, item['id'] as int?))
    .toList();

List<FoodModel> popularFoods = nearFoodData
    .map((item) =>
    FoodModel(item['title'] as String?, item['rating'] as int?, item['image'] as String?, item['vendor'] as String?, item['id'] as int?))
    .toList();

var nearFoodData = [
  {
    "id": 1,
    "title": "Bakso gurih Joko",
    "rating": 100,
    "image": "https://cdn-image.hipwee.com/wp-content/uploads/2016/09/hipwee-www.pinterest.com_-1.jpg",
    "vendor": "Pak Joko"
  },
  {
    "id": 2,
    "title": "Soto Ayam Gurih",
    "rating": 200,
    "image": "https://cdn-image.hipwee.com/wp-content/uploads/2016/09/hipwee-noezatravelfood.blogspot.com_-750x500.jpg",
    "vendor": "Pak Jana"
  },
  {
    "id": 3,
    "title": "Sate ayam manknyus",
    "rating": 40,
    "image": "https://cdn-image.hipwee.com/wp-content/uploads/2016/09/hipwee-beritagar.id_.jpg",
    "vendor": "Pak Jiki"
  },
  {
    "id": 4,
    "title": "Ketopak jakarta pak selamet selalu sayang mama",
    "rating": 40,
    "image": "https://cdn-image.hipwee.com/wp-content/uploads/2016/09/hipwee-www.klikhotel.com_-750x554.jpg",
    "vendor": "Pak Jeki"
  },
  {
    "id": 5,
    "title": "Bubur Ayam Emak",
    "rating": 40,
    "image": "https://cdn-image.hipwee.com/wp-content/uploads/2016/09/hipwee-makananenaksemarang.blogspot.com_-750x563.jpg",
    "vendor": "Pak Jaka"
  },
];