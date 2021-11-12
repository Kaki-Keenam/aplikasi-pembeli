import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/models/product_model.dart';
import 'package:kakikeenam/app/data/models/transaction_model.dart';
import 'package:kakikeenam/app/data/models/user_model.dart';
import 'package:kakikeenam/app/data/models/vendor_model.dart';
import 'package:kakikeenam/app/data/repository/repository_remote.dart';
import 'package:kakikeenam/app/utils/constants/constants.dart';

class DetailItemController extends GetxController {
  final RepositoryRemote _repositoryRemote = Get.find<RepositoryRemote>();
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
    _foodModel.bindStream(getProduct());
    getVendor();
    super.onReady();
  }

  @override
  void onInit() {
    _buyerLocation.bindStream(getBuyerLoc());
    super.onInit();
  }

  Stream<GeoPoint> getBuyerLoc(){
    return _repositoryRemote.buyerLoc().map((event) {
      var location = event.get('lastLocation');
      return location;
    });
  }



  Stream<List<ProductModel>> getProduct() {
    try {
      return _repositoryRemote
          .getProduct(vendorId.value)
          .map((QuerySnapshot query) {
        List<ProductModel> listData = List.empty(growable: true);
        query.docs.forEach((element) {
          listData.add(ProductModel.fromDocument(element));
        });
        return listData;
      });
    } catch (e) {
      print('vendorId: ${e.toString()}');
      rethrow;
    }
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
        .doc(_auth.currentUser!.uid)
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
          .doc(_auth.currentUser!.uid)
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
        "vendorName": food?.vendorName,
        "isFavorite": true,
        "updateTime": update,
      });

      await users
          .doc(_auth.currentUser!.uid)
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
          .doc(_auth.currentUser!.uid)
          .collection(Constants.FAVORITE)
          .doc(_auth.currentUser!.email)
          .get();
      final docFavorite =
          (docUser.data() as Map<String, dynamic>)[Constants.FAVORITES] as List;

      docFavorite.removeWhere((element) => element["productId"] == id);
      await users
          .doc(_auth.currentUser!.uid)
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
    _vendor.update((ven) {
      ven?.storeImage = data.get("storeImage");
      ven?.storeName = data.get("storeName");
      ven?.uid = data.get("uid");
      ven?.email = data.get("email");
      ven?.status = data.get("status");
      ven?.rating = data.get("rating");
      ven?.street = streetValue;
      ven?.distance = distance;
    });
  }

  void setTrans(ProductModel? product) async {
    try {
      var stringList =
          DateTime.now().toIso8601String().split(new RegExp(r"[T.]"));
      var formattedDate = "${stringList[0]} ${stringList[1]}.${stringList[2]}";
      UserModel user = await _repositoryRemote.userModel;
      VendorModel vendorModel = await _repositoryRemote.getVendor(product!.vendorId!);
      List<ProductModel> listData = List.empty(growable: true);
      listData.add(ProductModel(
        productId: product.productId,
        image: product.image,
        name: product.name,
        price: product.price,
      ));
      TransactionModel trans = TransactionModel(
        buyerId: user.uid,
        buyerLoc: user.lastLocation,
        buyerName: user.name,
        product: listData,
        storeImage: vendorModel.storeImage,
        storeName: vendorModel.storeName,
        orderDate: formattedDate,
        rating: vendorModel.rating,
        state: "PROPOSED",
        vendorId: vendorModel.uid
      );
      _repositoryRemote.setTrans(trans, product);
    } catch (e) {
      print('set trans: ${e.toString()}');
    }
  }
  void stateCancelConfirm(String? transId) {
    try {
      var trans = _dbStore.collection(Constants.TRANSACTION);
      trans.doc(transId).update({
        "state": "CANCEL",
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
