import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/models/product_model.dart';
import 'package:kakikeenam/app/data/models/transaction_model.dart';
import 'package:kakikeenam/app/data/models/user_model.dart';
import 'package:kakikeenam/app/data/models/vendor_model.dart';
import 'package:kakikeenam/app/data/repository/repository_remote.dart';
import 'package:kakikeenam/app/utils/constants/constants.dart';

class DetailItemController extends GetxController {
  final RepositoryRemote _repositoryRemote = Get.find<RepositoryRemote>();
  final TextEditingController addressC = TextEditingController();
  FirebaseFirestore _dbStore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  RxBool isFav = false.obs;

  GeocodingPlatform geoCoding = GeocodingPlatform.instance;

  var _user = UserModel().obs;
  UserModel get user => this._user.value;

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onInit() {
    _user.bindStream(_repositoryRemote.userModel);
    super.onInit();
  }

  RepositoryRemote get repo => this._repositoryRemote;

  Stream<List<ProductModel>> getProduct(String vendorId) {
    try {
      return _repositoryRemote
          .getProduct(vendorId)
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

  void addFavorite(ProductModel? food,) async {
    CollectionReference users = _dbStore.collection(Constants.BUYER);
    String update = DateTime.now().toIso8601String();
    try {
      final docUser = await users
          .doc(_auth.currentUser!.uid)
          .collection(Constants.FAVORITE)
          .doc(_auth.currentUser!.email)
          .get();
      final favorite =
          (docUser.data() as Map<String, dynamic>)[Constants.FAVORITES] as List;

      favorite.add({
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
          .update({Constants.FAVORITES: favorite});
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


  void setTrans(ProductModel? product) async {
    try {
      var stringList =
          DateTime.now().toIso8601String().split(new RegExp(r"[T.]"));
      var formattedDate = "${stringList[0]} ${stringList[1]}.${stringList[2]}";
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
        storeName: vendorModel.storeName,
        orderDate: formattedDate,
        rating: vendorModel.rating,
        address: addressC.text,
        state: "PROPOSED",
        vendorId: vendorModel.uid
      );
      _repositoryRemote.setTrans(trans, product);
    } catch (e) {
      print('set trans: ${e.toString()}');
    }
  }

  Future<int> reviews(String vendorId) async{
    return _repositoryRemote.getReviews(vendorId).then((value) {
      return value.docs.length;
    });
  }

  Future<VendorModel> vendorDetail(String vendorId) {
    return _repositoryRemote.getVendor(vendorId);
  }
}
