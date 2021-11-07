
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/models/product_model.dart';
import 'package:kakikeenam/app/data/models/user_model.dart';
import 'package:kakikeenam/app/data/models/vendor_model.dart';
import 'package:kakikeenam/app/data/repository/repository_remote.dart';
import 'package:kakikeenam/app/utils/constants/constants.dart';


class HomeController extends GetxController {
  final RepositoryRemote _repositoryRemote = Get.find<RepositoryRemote>();
  FirebaseFirestore _db = FirebaseFirestore.instance;
  Rxn<List<ProductModel>> searchList = Rxn<List<ProductModel>>();

  List<ProductModel>? get searchData => searchList.value;

  Rxn<List<VendorModel>> _vendor = Rxn<List<VendorModel>>();

  List<VendorModel>? get vendorID => this._vendor.value;

  var currentIndex = 0.obs;
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result.obs;
  }

  var _user = UserModel().obs;

  UserModel get user => this._user.value;

  @override
  void onInit() {
    initUser();
    _vendor.bindStream(vendorId());
    super.onInit();
  }

  initUser() async {
    try{
      var _userData = await _repositoryRemote.userModel;
      _user(_userData);
    }catch(e){
      print('user: ${e.toString()}');
    }
  }

  Stream<List<ProductModel>> streamProduct(List<VendorModel>? query) {
    List<String> queryList = List.empty(growable: true);
    query?.forEach((element) {
      queryList.add(element.uid ?? "");
    });
    try {
      return _db
          .collection(Constants.PRODUCTS)
          .where(Constants.VENDOR_ID_QUERY, whereIn: queryList)
          .snapshots()
          .map((QuerySnapshot query) {
        List<ProductModel> listData = List.empty(growable: true);
        query.docs.forEach((element) {
          listData.add(ProductModel.fromDocument(element));
        });
        return listData;
      });
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Stream<List<VendorModel>?> vendorId(){
    return _repositoryRemote.getStreamVendorId().map((vendor) {
      if(ConnectionState == ConnectionState.active){
        vendor.map((event) {
          return event;
        });
      }
       return null;
    });
  }

}
