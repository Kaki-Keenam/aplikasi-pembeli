import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/models/favorite_model.dart';
import 'package:kakikeenam/app/utils/constants/constants.dart';

class DetailItemController extends GetxController {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  var fav = FavoriteModel().obs;
  RxBool isFav = false.obs;

  void initFav(String? id) async {
    isFavorite(id).then((value) => {if (value) isFav.value = true});
  }

  Future<bool> isFavorite([String? id]) async {
    CollectionReference users = _firestore.collection(Constants.BUYER);
    final docUser = await users
        .doc(_auth.currentUser!.email)
        .collection(Constants.FAVORITE)
        .doc(_auth.currentUser!.email)
        .get();
    final docFavorite =
        (docUser.data() as Map<String, dynamic>)[Constants.FAVORITES] as List;
    for (var f in docFavorite) {
      if (f["id"] == id) {
        return true;
      }
    }
    update();
    return false;
  }

  void addFavorite({
    String? id,
    String? title,
    String? rating,
    String? image,
    String? vendor,
  }) async {
    CollectionReference users = _firestore.collection(Constants.BUYER);
    String date = DateTime.now().toIso8601String();

    try {
      final docUser = await users
          .doc(_auth.currentUser!.email)
          .collection(Constants.FAVORITE)
          .doc(_auth.currentUser!.email)
          .get();
      final docFavorite =
          (docUser.data() as Map<String, dynamic>)[Constants.FAVORITES] as List;

      docFavorite.add({
        "id": id,
        "title": title,
        "rating": rating,
        "image": image,
        "vendor": vendor,
        "isFavorite": true,
        "lastTime": date,
      });

      await users
          .doc(_auth.currentUser!.email)
          .collection(Constants.FAVORITE)
          .doc(_auth.currentUser!.email)
          .update({Constants.FAVORITES: docFavorite});

      List<Favorite> dataList = List<Favorite>.empty(growable: true);
      docFavorite.forEach((element) {
        dataList.add(Favorite(
          id: element["id"],
          title: element["title"],
          rating: element["rating"],
          image: element["image"],
          vendor: element["vendor"],
          isFavorite: true,
          lastTime: date,
        ));
      });
      fav.update((user) {
        user!.favorite = dataList;
      });
      fav.refresh();
    } catch (e) {
      print(e.toString());
    }
    update();
  }

  void removeFavorite(String? id) async {
    CollectionReference users = _firestore.collection(Constants.BUYER);

    try {
      final docUser = await users
          .doc(_auth.currentUser!.email)
          .collection(Constants.FAVORITE)
          .doc(_auth.currentUser!.email)
          .get();
      final docFavorite =
          (docUser.data() as Map<String, dynamic>)[Constants.FAVORITES] as List;

      List<Favorite> dataList = List<Favorite>.empty(growable: true);

      docFavorite.removeWhere((element) => element["id"] == id);
      dataList.removeWhere((element) => element.id == id);
      await users
          .doc(_auth.currentUser!.email)
          .collection(Constants.FAVORITE)
          .doc(_auth.currentUser!.email)
          .update({Constants.FAVORITES: docFavorite});

      fav.update((user) {
        user!.favorite = dataList;
      });
      fav.refresh();
    } catch (e) {
      print(e.toString());
    }
    update();
  }
}
