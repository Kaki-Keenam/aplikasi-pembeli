
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/models/product_model.dart';
import 'package:kakikeenam/app/data/models/user_model.dart';
import 'package:kakikeenam/app/data/models/vendor_model.dart';
import 'package:kakikeenam/app/data/repository/repository_remote.dart';
import 'package:kakikeenam/app/data/services/helper_controller.dart';
import 'package:kakikeenam/app/data/services/location_service.dart';
import 'package:kakikeenam/app/utils/constants/constants.dart';


class HomeController extends GetxController {
  final RepositoryRemote _repositoryRemote = Get.find<RepositoryRemote>();
  final LocationController locationService = Get.find<LocationController>();
  final HelperController helper = Get.put(HelperController(), permanent: true);
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
    initUser();
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

}
