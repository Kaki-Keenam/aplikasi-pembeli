
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/database/database.dart';
import 'package:kakikeenam/app/data/models/product_model.dart';

class FavoriteController extends GetxController {
  var searchFav = TextEditingController();
  var fav = ProductModel().obs;

  Rxn<List<ProductModel>> foodModel = Rxn<List<ProductModel>>();
  List<ProductModel>? get food => foodModel.value;

  @override
  void onInit() {
    foodModel.bindStream(Database().streamListFavorite());
    super.onInit();
  }

  @override
  void onClose() {
    searchFav.dispose();
    super.onClose();
  }

}
