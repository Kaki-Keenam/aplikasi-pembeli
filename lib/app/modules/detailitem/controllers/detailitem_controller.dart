import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/database/database.dart';
import 'package:kakikeenam/app/data/models/favorite_model.dart';
import 'package:kakikeenam/app/data/models/product_model.dart';
import 'package:kakikeenam/app/data/models/vendor_model.dart';
import 'package:kakikeenam/app/utils/constants/constants.dart';

class DetailItemController extends GetxController {
  FirebaseFirestore _dbStore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  RxBool isFav = false.obs;
  var vendorId = "".obs;
  var _vendor = VendorModel().obs;
  Rxn<GeoPoint> _buyerLocation = Rxn<GeoPoint>();

  VendorModel get getVendorModel => _vendor.value;
  GeoPoint? get getBuyerLocation => _buyerLocation.value;

  Rxn<List<ProductModel>> _foodModel = Rxn<List<ProductModel>>();

  List<ProductModel>? get foodOther => _foodModel.value;
  GeocodingPlatform geoCoding = GeocodingPlatform.instance;

  @override
  void onReady() {
    _foodModel.bindStream(Database().getStreamProduct(vendorId.value));
    getVendor();
    super.onReady();
  }
  @override
  void onInit() {
    _buyerLocation.bindStream(Database().streamBuyerLoc());
    super.onInit();
  }

  // TODO REVISI CODE
  void initFav(String? id) async {
    isFavorite(id).then((value) => {if (value) isFav.value = true});
  }

  /// other products
  set setVendorId(String _vendorId) => this.vendorId.value = _vendorId;

  Future<bool> isFavorite([String? id]) async {
    CollectionReference users = _dbStore.collection(Constants.BUYER);
    final docUser = await users
        .doc(_auth.currentUser!.email)
        .collection(Constants.FAVORITE)
        .doc(_auth.currentUser!.email)
        .get();
    final docFavorite =
    (docUser.data() as Map<String, dynamic>)[Constants.FAVORITES] as List;
    for (var f in docFavorite) {
      if (f["productId"] == id) {
        return true;
      }
    }
    update();
    return false;
  }

  void addFavorite({ProductModel? food}) async {
    CollectionReference users = _dbStore.collection(Constants.BUYER);
    String update = DateTime.now().toIso8601String();
    try {
      final docUser = await users
          .doc(_auth.currentUser!.email)
          .collection(Constants.FAVORITE)
          .doc(_auth.currentUser!.email)
          .get();
      final docFavorite =
      (docUser.data() as Map<String, dynamic>)[Constants.FAVORITES] as List;

      docFavorite.add({
        "productId": food?.productId,
        "name": food?.name,
        "image": food?.image,
        "price": food?.price,
        "vendorId": food?.vendorId,
        "isFavorite": true,
        "updateTime": update,
      });

      await users
          .doc(_auth.currentUser!.email)
          .collection(Constants.FAVORITE)
          .doc(_auth.currentUser!.email)
          .update({Constants.FAVORITES: docFavorite});
    } catch (e) {
      print(e.toString());
    }
  }

  void removeFavorite(String? id) async {
    CollectionReference users = _dbStore.collection(Constants.BUYER);
    try {
      final docUser = await users
          .doc(_auth.currentUser!.email)
          .collection(Constants.FAVORITE)
          .doc(_auth.currentUser!.email)
          .get();
      final docFavorite =
      (docUser.data() as Map<String, dynamic>)[Constants.FAVORITES] as List;

      List<Favorite> dataList = List<Favorite>.empty(growable: true);

      docFavorite.removeWhere((element) => element["productId"] == id);
      dataList.removeWhere((element) => element.productId == id);
      await users
          .doc(_auth.currentUser!.email)
          .collection(Constants.FAVORITE)
          .doc(_auth.currentUser!.email)
          .update({Constants.FAVORITES: docFavorite});
    } catch (e) {
      print(e.toString());
    }
    update();
  }

  void getVendor() async {
      CollectionReference ven = _dbStore.collection(Constants.VENDOR);
      DocumentSnapshot data = await ven.doc(vendorId.value).get();
      var lastLocation = data.get("lastLocation") ??
          GeoPoint(-8.58189186561154, 116.10003256768428);
      List<Placemark> street = await geoCoding.placemarkFromCoordinates(
          lastLocation.latitude, lastLocation.longitude);
      String streetValue = "${street.first.street} ${street.first.subLocality}";
      double distance = Geolocator.distanceBetween(
          getBuyerLocation!.latitude,
          getBuyerLocation!.longitude,
          lastLocation.latitude,
          lastLocation.longitude);
      _vendor.update((ven){
        ven?.image = data.get("storeImage");
        ven?.storeName = data.get("storeName");
        ven?.uid = data.get("uid");
        ven?.email = data.get("email");
        ven?.status = data.get("status");
        ven?.rating = data.get("rating");
        ven?.street = streetValue;
        ven?.distance = distance;
      });

  }
}
