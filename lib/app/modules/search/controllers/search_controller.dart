import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/models/product_model.dart';
import 'package:kakikeenam/app/modules/home/controllers/home_controller.dart';

class SearchController extends GetxController {
  var searchC = TextEditingController();

  Rxn<List<ProductModel>> fromHome = Rxn<List<ProductModel>>();
  List<ProductModel>? get searchData => fromHome.value;

  Rxn<List<ProductModel>> resultData = Rxn<List<ProductModel>>();
  List<ProductModel>? get searchResult => resultData.value;


  @override
  void onInit() {
    fromHome.value = Get.find<HomeController>().searchData;
    super.onInit();
  }

  @override
  void onClose() {
    searchC.dispose();
    super.onClose();
  }

  void searchFood(String data){
    if(data.length == 0){
      resultData.value = [];
    }else {
      var capitalized = data.substring(0, 1).toUpperCase() + data.substring(1);
      print(capitalized);
      if (searchData?.length != 0) {
        resultData.value = [];
        searchData?.forEach((element) {
          if (element.name!.contains(capitalized) || element.name!.contains(data)) {
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
}
