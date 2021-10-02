import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/models/favorite_model.dart';
import 'package:kakikeenam/app/data/models/product_model.dart';
import 'package:kakikeenam/app/data/models/vendor_model.dart';
import 'package:kakikeenam/app/utils/constants/constants.dart';

class DetailItemController extends GetxController {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  RxBool isFav = false.obs;
  var vendorId = "".obs;
  var vendor = VendorModel().obs;

  set setVendor(VendorModel data) => vendor.value = data;
  Rxn<List<ProductModel>> _foodModel = Rxn<List<ProductModel>>();
  List<ProductModel>? get foodOther => _foodModel.value;
  GeocodingPlatform geoCoding = GeocodingPlatform.instance;

  @override
  void onReady() {
    _foodModel.bindStream(getStreamData());
    getVendor();
    super.onReady();
  }

  // TODO REVISI CODE
  void initFav(String? id) async {
    isFavorite(id).then((value) => {if (value) isFav.value = true});
  }

  Future<bool> isFavorite([String? id]) async {
    CollectionReference users = _firestore.collection(Constants.BUYER);
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
    CollectionReference users = _firestore.collection(Constants.BUYER);
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
    CollectionReference users = _firestore.collection(Constants.BUYER);

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

  /// other products
  set setVendorId(String _vendorId) => this.vendorId.value = _vendorId;

  //Stream
  Stream<List<ProductModel>> getStreamData() {
    return _firestore
        .collection(Constants.PRODUCTS)
        .where("vendorId", isEqualTo: vendorId.value)
        .snapshots()
        .map((QuerySnapshot query) {
      List<ProductModel> listData = List.empty(growable: true);
      query.docs.forEach((element) {
        listData.add(ProductModel.fromDocument(element));
      });
      _foodModel.refresh();
      return listData;
    });
  }

  void getVendor() async {
   try{
     CollectionReference ven = _firestore
         .collection(Constants.VENDOR);
     DocumentSnapshot data  = await ven.doc(vendorId.value).get();
     var lastLocation = data.get("lastLocation") == null ? GeoPoint(-8.58189186561154, 116.10003256768428) :  GeoPoint(-8.58189186561154, 116.10003256768428);
     List<Placemark> street = await geoCoding.placemarkFromCoordinates(lastLocation.latitude, lastLocation.longitude);
     String streetValue = "${street.first.street} ${street.first.subLocality}";

     vendor.update((ven) {
       ven?.image = data.get("storeImage");
       ven?.storeName = data.get("storeName");
       ven?.uid = data.get("uid");
       ven?.email = data.get("email");
       ven?.status = data.get("status");
       ven?.rating = data.get("rating").toString();
       ven?.street = streetValue;
     });
   }catch (e){
     print(e.toString());
   }

  }
}
