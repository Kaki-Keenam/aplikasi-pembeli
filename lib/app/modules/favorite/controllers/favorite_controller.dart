
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/models/product_model.dart';
import 'package:kakikeenam/app/data/repository/repository_remote.dart';

class FavoriteController extends GetxController {
  var searchFav = TextEditingController();
  final RepositoryRemote _repositoryRemote = Get.find<RepositoryRemote>();
  var fav = ProductModel().obs;

  Rxn<List<ProductModel>> foodModel = Rxn<List<ProductModel>>();
  List<ProductModel>? get food => foodModel.value;

  @override
  void onReady() {
    foodModel.bindStream(getFavorite());
    super.onReady();
  }

  Stream<List<ProductModel>> getFavorite(){
    try{
      return _repositoryRemote.streamListFavorite().map((DocumentSnapshot doc) {
        var fav = doc.data() as dynamic;
        var data = fav["favorites"];
        List<ProductModel> listData = List.empty(growable: true);
        data.forEach((element) {
          listData.add(ProductModel.fromMap(element));
        });
        return listData;
      });
    }catch(e){
      print('favorite: ${e.toString()}');
      rethrow;
    }
  }

  @override
  void onClose() {
    searchFav.dispose();
    super.onClose();
  }


}
