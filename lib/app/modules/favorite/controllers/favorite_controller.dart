
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/models/product_model.dart';
import 'package:kakikeenam/app/data/repository/repository_remote.dart';

class FavoriteController extends GetxController {
  final TextEditingController searchInputController = TextEditingController();
  final RepositoryRemote _repositoryRemote = Get.find<RepositoryRemote>();

  Rxn<List<ProductModel>> foodModel = Rxn<List<ProductModel>>();
  List<ProductModel>? get food => foodModel.value;

  Rxn<List<ProductModel>> resultData = Rxn<List<ProductModel>>();
  List<ProductModel>? get searchResult => resultData.value;

  @override
  void onReady() {
    foodModel.bindStream(getFavorite());
    super.onReady();
  }

  var popularRecipeKeyword = ['Cilok', 'Bakso', 'Rujak', 'Roti', 'Ice Cream', 'Bakmi'];

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


  void searchFood(String searchText){
    if(searchText.length == 0){
      resultData.value = [];
    }else {
      var capitalized = searchText.substring(0, 1).toUpperCase() + searchText.substring(1);
      if (food?.length != 0) {
        resultData.value = [];
        food?.forEach((element) {
          if (element.name!.contains(capitalized) || element.name!.contains(searchText)) {
            print("food ${element.name}");
            resultData.value?.add(ProductModel(
              productId: element.productId,
              vendorId: element.vendorId,
              name: element.name,
              price: element.price,
              vendorName: element.vendorName,
              image: element.image,
              isFavorite: element.isFavorite,
              creationTime: element.creationTime,
              updateTime: element.updateTime,
            ));
          }
        });
        resultData.refresh();
      }
    }
  }

  @override
  void onClose() {
    searchInputController.dispose();
    super.onClose();
  }


}
