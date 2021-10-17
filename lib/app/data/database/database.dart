import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';

import 'package:kakikeenam/app/data/models/product_model.dart';
import 'package:kakikeenam/app/data/models/transaction_model.dart';
import 'package:kakikeenam/app/data/models/vendor_model.dart';
import 'package:kakikeenam/app/utils/constants/constants.dart';

class Database {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  GeocodingPlatform geoCoding = GeocodingPlatform.instance;


  //PRODUCT
  Stream<List<ProductModel>> streamProduct(List<VendorModel>? query) {
    List<String> queryList = List.empty(growable: true);
    query?.forEach((element) {
      queryList.add(element.uid ?? "");
    });
    try {
      return _firestore
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
      print("streamProduct service: ${e.toString()}");
      rethrow;
    }
  }

  //VENDOR
  Stream<List<VendorModel>?> streamVendorId(GeoPoint? location) {
    try {
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
      return _firestore
          .collection(Constants.VENDOR)
          .where(Constants.LAST_LOCATION,
              isGreaterThanOrEqualTo: lesserGeoPoint)
          .where(Constants.LAST_LOCATION, isLessThanOrEqualTo: greaterGeoPoint)
          .snapshots()
          .map((QuerySnapshot query) {
        List<VendorModel> listData = List.empty(growable: true);
        query.docs.forEach((element) {
          var data = element.data() as dynamic;
          listData.add(VendorModel(
            uid: data["uid"],
          ));
        });
        return listData;
      });
    } catch (e) {
      print("streamvendorid service: ${e.toString()}");
      rethrow;
    }
  }

  //BuyerLocation
  Stream<GeoPoint> streamBuyerLoc() {
    try {
      return _firestore
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
    return _firestore
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
      return _firestore
          .collection(Constants.BUYER)
          .doc(_auth.currentUser!.email)
          .collection(Constants.FAVORITE)
          .doc(_auth.currentUser!.email)
          .snapshots()
          .map((DocumentSnapshot doc) {
        var fav = doc.data() as dynamic;
        var data = fav["favorites"];
        List<ProductModel> listData = List.empty(growable: true);
        data.forEach((element) {
          listData.add(ProductModel.fromMap(element));
        });
        return listData;
      });
    } catch (e) {
      print("streamFavorite service: ${e.toString()}");
      rethrow;
    }
  }

  //TRANSACTION
  Stream<List<TransactionModel>> streamListTrans() {
    try {
      return _firestore
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
      print("streamTrans service: ${e.toString()}");
      rethrow;
    }
  }

  // Search Data

}
