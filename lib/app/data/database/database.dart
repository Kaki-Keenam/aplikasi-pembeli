import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kakikeenam/app/data/models/product_model.dart';
import 'package:kakikeenam/app/data/models/transaction_model.dart';
import 'package:kakikeenam/app/utils/constants/constants.dart';

class Database {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  //PRODUCT
  Stream<List<ProductModel>> streamProduct(List<String>? query) {
    try{
      return _firestore
          .collection(Constants.PRODUCTS)
          .where("vendorId", whereIn: query)
          .snapshots()
          .map((QuerySnapshot query) {
        List<ProductModel> listData = List.empty(growable: true);
        query.docs.forEach((element) {
          listData.add(ProductModel.fromDocument(element));
        });
        return listData;
      });
    }catch (e){
      print(e.toString());
      rethrow;
    }
  }

  //VENDOR
  Stream<List<String>> streamVendorId(GeoPoint? location) {
    try{
      double distanceInMile = 0.25;
      double lat = 0.0144927536231884;
      double lon = 0.0181818181818182;

      double lowerLat = location!.latitude - (lat * distanceInMile);
      double lowerLong = location.longitude - (lon * distanceInMile);

      double greaterLat = location.latitude + (lat * distanceInMile);
      double greaterLong = location.longitude + (lon * distanceInMile);

      GeoPoint lesserGeoPoint = GeoPoint(lowerLat, lowerLong);
      GeoPoint greaterGeoPoint = GeoPoint(greaterLat, greaterLong);
      return _firestore
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
    }catch (e){
      print(e.toString());
      rethrow;
    }
  }

  //BuyerLocation
  Stream<GeoPoint> streamBuyerLoc() {
    try{
      return _firestore
          .collection(Constants.BUYER)
          .doc(_auth.currentUser!.email)
          .snapshots()
          .map((DocumentSnapshot doc) => doc.get("lastLocation"));
    }catch (e){
      print(e.toString());
      rethrow;
    }
  }

  Stream<List<ProductModel>> streamListFavorite() {
    try{
      return _firestore
          .collection(Constants.BUYER)
          .doc(_auth.currentUser!.email)
          .collection(Constants.FAVORITE)
          .doc(_auth.currentUser!.email)
          .snapshots().map((DocumentSnapshot doc) {
        var fav = doc.data() as dynamic;
        var data = fav["favorites"];
        List<ProductModel> listData = List.empty(growable: true);
        data.forEach((element) {
          listData.add(ProductModel.fromMap(element));
        });
        return listData;
      });
    } catch (e){
      print(e.toString());
      rethrow;
    }
  }

  //TRANSACTION
  Stream<List<TransactionModel>> streamListTrans() {
    try{
      return _firestore
          .collection(Constants.TRANSACTION)
          .orderBy("orderDate", descending: true)
          .where("buyerId", isEqualTo: _auth.currentUser?.uid)
          .snapshots()
          .map((QuerySnapshot query) {
        List<TransactionModel> listData = List.empty(growable: true);
        query.docs.forEach((element) {
          listData.add(TransactionModel.fromDocument(element));
        });
        return listData;
      });
    }catch(e){
      print(e.toString());
      rethrow;
    }
  }
}
