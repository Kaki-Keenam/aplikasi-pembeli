
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/models/product_model.dart';

class HomeController extends GetxController {
  var currentIndex = 0.obs;

  // PRODUCT
  Rxn<List<ProductModel>> _productModel = Rxn<List<ProductModel>>();
  List<ProductModel>? get product => _productModel.value;

  // VENDOR
  Rxn<List<String>> _vendorModel = Rxn<List<String>>();
  List<String>? get vendor => _vendorModel.value;

  //VENDOR
  Rxn<GeoPoint> _geoPoint = Rxn<GeoPoint>();
  GeoPoint? get location => _geoPoint.value;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result.obs;
  }

  @override
  void onInit() {

    super.onInit();
  }
}
