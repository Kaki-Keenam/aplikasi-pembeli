
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/models/product_model.dart';


class HomeController extends GetxController with SingleGetTickerProviderMixin {

  Rxn<List<ProductModel>> searchList = Rxn<List<ProductModel>>();

  List<ProductModel>? get searchData => searchList.value;

  var currentIndex = 0.obs;
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result.obs;
  }

}
