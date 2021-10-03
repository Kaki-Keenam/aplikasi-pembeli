import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:kakikeenam/app/data/models/product_model.dart';
import 'package:kakikeenam/app/data/models/transaction_model.dart';
import 'package:kakikeenam/app/utils/constants/constants.dart';

class Database {
  FirebaseFirestore _dbStore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  GeocodingPlatform geoCoding = GeocodingPlatform.instance;

  //PRODUCT
  Stream<List<ProductModel>> streamProduct(List<String>? query) {
    try {
      return _dbStore
          .collection(Constants.PRODUCTS)
          .where(Constants.VENDOR_ID_QUERY, whereIn: query)
          .where(Constants.STATUS_QUERY, isEqualTo: Constants.ONLINE)
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

  //VENDOR
  Stream<List<String>> streamVendorId(GeoPoint? location) {
    try {
      double lowerLat = location!.latitude -
          (Constants.DISTANCE_LATITUDE * Constants.DISTANCE_MILE);
      double lowerLong = location.longitude -
          (Constants.DISTANCE_LONGITUDE * Constants.DISTANCE_MILE);

      double greaterLat = location.latitude +
          (Constants.DISTANCE_LATITUDE * Constants.DISTANCE_MILE);
      double greaterLong = location.longitude +
          (Constants.DISTANCE_LONGITUDE * Constants.DISTANCE_MILE);

      GeoPoint lesserGeoPoint = GeoPoint(lowerLat, lowerLong);
      GeoPoint greaterGeoPoint = GeoPoint(greaterLat, greaterLong);
      return _dbStore
          .collection(Constants.VENDOR)
          .where('lastLocation', isGreaterThanOrEqualTo: lesserGeoPoint)
          .where('lastLocation', isLessThanOrEqualTo: greaterGeoPoint)
          .snapshots()
          .map((QuerySnapshot query) {
        List<String> listData = List.empty(growable: true);
        query.docs.forEach((element) {
          var data = element.data() as dynamic;
          listData.add(data["uid"]);
        });
        return listData;
      });
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  //BuyerLocation
  Stream<GeoPoint> streamBuyerLoc() {
    try {
      return _dbStore
          .collection(Constants.BUYER)
          .doc(_auth.currentUser!.email)
          .snapshots()
          .map((DocumentSnapshot doc) => doc.get("lastLocation"));
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  //Stream product in detail
  Stream<List<ProductModel>> getStreamProduct(String vendorId) {
    return _dbStore
        .collection(Constants.PRODUCTS)
        .where(Constants.VENDOR_ID_QUERY, isEqualTo: vendorId)
        .snapshots()
        .map((QuerySnapshot query) {
      List<ProductModel> listData = List.empty(growable: true);
      query.docs.forEach((element) {
        listData.add(ProductModel.fromDocument(element));
      });
      return listData;
    });
  }

  Stream<List<ProductModel>> streamListFavorite() {
    try {
      return _dbStore
          .collection(Constants.BUYER)
          .doc(_auth.currentUser!.email)
          .collection(Constants.FAVORITE)
          .doc(_auth.currentUser!.email)
          .snapshots()
          .map((DocumentSnapshot doc) {
        var fav = doc.data() as dynamic;
        var data = fav[Constants.FAVORITES];
        List<ProductModel> listData = List.empty(growable: true);
        data.forEach((element) {
          listData.add(ProductModel.fromMap(element));
        });
        return listData;
      });
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  //TRANSACTION
  Stream<List<TransactionModel>> streamListTrans() {
    try {
      return _dbStore
          .collection(Constants.TRANSACTION)
          .orderBy(Constants.ORDER_DATE, descending: true)
          .where(Constants.BUYER_ID_QUERY, isEqualTo: _auth.currentUser?.uid)
          .snapshots()
          .map((QuerySnapshot query) {
        List<TransactionModel> listData = List.empty(growable: true);
        query.docs.forEach((element) {
          listData.add(TransactionModel.fromDocument(element));
        });
        return listData;
      });
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
