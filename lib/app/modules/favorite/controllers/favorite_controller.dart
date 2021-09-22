import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/models/favorite_model.dart';
import 'package:kakikeenam/app/utils/constants/constants.dart';

class FavoriteController extends GetxController {
  var searchFav = TextEditingController();
  var fav = FavoriteModel().obs;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  List<Favorite> listFav = List<Favorite>.empty(growable: true);

  List? setDataList([dynamic data]) {
    try {
      String date = DateTime.now().toIso8601String();
      List<Favorite> _dataList = List<Favorite>.empty(growable: true);
      for (var list in data) {
        _dataList.add(Favorite(
          id: list["id"],
          title: list["title"],
          rating: list["rating"],
          image: list["image"],
          vendor: list["vendor"],
          isFavorite: true,
          lastTime: date,
        ));
      }
      fav.update((user) {
        user!.favorite = _dataList;
        listFav = _dataList;
      });
      fav.refresh();
      return _dataList;
    } catch (e) {
      return null;
    }
  }

  Stream<DocumentSnapshot?> getListFav() {
    var users = _firestore
        .collection(Constants.BUYER)
        .doc(_auth.currentUser!.email)
        .collection(Constants.FAVORITE)
        .doc(_auth.currentUser!.email)
        .snapshots();
    return users;
  }

  @override
  void onClose() {
    searchFav.dispose();
    super.onClose();
  }

}
