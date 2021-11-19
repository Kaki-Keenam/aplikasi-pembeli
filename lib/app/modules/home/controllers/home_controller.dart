
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/models/banner_model.dart';
import 'package:kakikeenam/app/data/models/product_model.dart';
import 'package:kakikeenam/app/data/models/user_model.dart';
import 'package:kakikeenam/app/data/models/vendor_model.dart';
import 'package:kakikeenam/app/data/repository/repository_remote.dart';
import 'package:kakikeenam/app/data/services/helper_controller.dart';
import 'package:kakikeenam/app/data/services/location_service.dart';
import 'package:kakikeenam/app/data/services/messaging/fcm.dart';
import 'package:kakikeenam/app/utils/constants/constants.dart';


class HomeController extends GetxController {
  final RepositoryRemote _repositoryRemote = Get.find<RepositoryRemote>();
  final LocationController locationService = Get.find<LocationController>();
  final HelperController _helper = Get.find<HelperController>();

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

  var _user = UserModel().obs;

  UserModel get user => this._user.value;

  @override
  void onInit() {
    _user.bindStream(_repositoryRemote.userModel);
    setFcm();
    super.onInit();
  }

  @override
  void onReady(){
    _helper.connectivitySubscription.onData((data) {
      if(data == ConnectivityResult.none){
        Get.defaultDialog(
            title: 'Tidak ada koneksi internet',
            middleText: 'Aktifkan koneksi anda !',
            textConfirm: 'Ok',
            onConfirm: Get.back
        );
      }
    });
    super.onReady();
  }

  void setFcm() async{
    var uid = await _repositoryRemote.user;
    Fcm().initFirebaseMessaging(userId: uid.uid);
  }

  Stream<GeoPoint> getBuyerLoc(){
    return _repositoryRemote.buyerLoc().map((event) {
      var location = event.get('lastLocation');
      return location;
    });
  }

  Stream<List<VendorModel>> getVendorId(GeoPoint? location){
    try{
      double lowerLat =
          location!.latitude - (Constants.LAT * Constants.DISTANCE_MILE);
      double lowerLong =
          location.longitude - (Constants.LONG * Constants.DISTANCE_MILE);

      double greaterLat =
          location.latitude + (Constants.LAT * Constants.DISTANCE_MILE);
      double greaterLong =
          location.longitude + (Constants.LONG * Constants.DISTANCE_MILE);

      GeoPoint lesserGeoPoint = GeoPoint(lowerLat, lowerLong);
      GeoPoint greaterGeoPoint = GeoPoint(greaterLat, greaterLong);
      return _repositoryRemote.vendorId(lesserGeoPoint, greaterGeoPoint).map((event) {
        List<VendorModel> listData = List.empty(growable: true);
        event.docs.forEach((element) {
          var data = element.data() as dynamic;
          listData.add(VendorModel(
            uid: data['uid'],
          ));
        });
        return listData;
      });
    }catch(e){
      print('vendorId: ${e.toString()}');
      rethrow;
    }
  }

  Stream<List<ProductModel>> getNearProduct(List<VendorModel>? query) {
    List<String> queryList = List.empty(growable: true);
    query?.forEach((element) {
      queryList.add(element.uid ?? "");
    });
    return _repositoryRemote.nearProduct(queryList).map((QuerySnapshot query) {
      List<ProductModel> listData = List.empty(growable: true);
      query.docs.forEach((element) {
        listData.add(ProductModel.fromDocument(element));
      });
      return listData;
    });
  }

  Future<VendorModel> getVendor(String? vendorId) {
    return _repositoryRemote.getVendor(vendorId!);
  }

  Future<BannerModel> getBanner(){
    return _repositoryRemote.getBanner().then((banner) {
      List<Result> listData = List.empty(growable: true);
      banner.docs.forEach((data) {
        listData.add(Result.fromJson(data.data() as Map<String, dynamic>));
      });
      return BannerModel(result: listData);
    });
  }

}
