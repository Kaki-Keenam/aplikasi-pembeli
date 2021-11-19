import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kakikeenam/app/data/models/product_model.dart';
import 'package:kakikeenam/app/data/models/review_model.dart';
import 'package:kakikeenam/app/data/models/transaction_model.dart';
import 'package:kakikeenam/app/data/models/user_model.dart';
import 'package:kakikeenam/app/utils/constants/constants.dart';
import 'package:kakikeenam/app/utils/utils.dart';

class DbRemote{
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<UserModel> getUserModel() {
    return _db.collection(Constants.BUYER).doc(_auth.currentUser?.uid).snapshots()
      .map((DocumentSnapshot doc) {
      var userModel = UserModel.fromDocument(doc.data() as Map<String, dynamic>);
      return userModel;
    });
  }

  Future<UserModel> userModel() {
    return _db.collection(Constants.BUYER).doc(_auth.currentUser?.uid).get()
        .then((value) {
      var userModel = UserModel.fromDocument(value.data() as Map<String, dynamic>);
      return userModel;
    });
  }

  void editName(String name) async {
    CollectionReference users = _db.collection(Constants.BUYER);
    try {
      await users.doc(_auth.currentUser!.uid).update({
        "name": name,
      });
      Dialogs.editSuccess();
    } catch (e) {
      Dialogs.errorDialog(e.toString());
    }
  }

  /// Update photo profile
  void updatePhoto(String url) async {
    String date = DateTime.now().toIso8601String();
    CollectionReference users = _db.collection(Constants.BUYER);
    try {
      await users.doc(_auth.currentUser!.uid).update({
        "photoUrl": url,
        "updateTime": date,
      });
    } catch (e) {
      Dialogs.errorDialog(e.toString());
    }
  }

  Stream<DocumentSnapshot> streamBuyerLoc() {
    try {
      var doc = _db
          .collection(Constants.BUYER)
          .doc(_auth.currentUser?.uid)
          .snapshots();
      return doc;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }


  Stream<QuerySnapshot> vendorId(GeoPoint lesserGeoPoint, GeoPoint greaterGeoPoint){
    try{
      return _db
          .collection(Constants.VENDOR)
          .where(Constants.LAST_LOCATION,
          isGreaterThanOrEqualTo: lesserGeoPoint)
          .where(Constants.LAST_LOCATION, isLessThanOrEqualTo: greaterGeoPoint)
          .snapshots();
    }catch(e){
      print('vendor location: ${e.toString()}');
      rethrow;
    }
  }

  Stream<QuerySnapshot> streamProduct(List<String> queryList){
    return _db
        .collection(Constants.PRODUCTS)
        .where(Constants.VENDOR_ID_QUERY, whereIn: queryList)
        .snapshots();
  }

  Stream<QuerySnapshot> getStreamData(String vendorId){
    try{
      return _db.collection(Constants.PRODUCTS)
          .where(Constants.VENDOR_ID_QUERY, isEqualTo: vendorId)
          .snapshots();
    }catch(e){
      print('vendorId : ${e.toString()}');
      rethrow;
    }
  }

  Stream<DocumentSnapshot> streamFavorite(){
    try{
      return _db
          .collection(Constants.BUYER)
          .doc(_auth.currentUser!.uid)
          .collection(Constants.FAVORITE)
          .doc(_auth.currentUser!.email)
          .snapshots();
    }catch(e){
      print('favorite: ${e.toString()}');
      rethrow;
    }
  }

  Stream<QuerySnapshot> streamTrans(){
    try{
      return _db
          .collection(Constants.TRANSACTION)
          .orderBy(Constants.ORDER_DATE, descending: true)
          .where(Constants.BUYER_ID_QUERY, isEqualTo: _auth.currentUser?.uid)
          .snapshots();
    }catch(e){
      print('trans: ${e.toString()}');
      rethrow;
    }
  }

  Future<QuerySnapshot> futureTrans() async {
    try{
      return _db
          .collection(Constants.TRANSACTION)
          .orderBy(Constants.ORDER_DATE, descending: true)
          .where(Constants.BUYER_ID_QUERY, isEqualTo: _auth.currentUser?.uid)
          .get();
    }catch(e){
      print('trans: ${e.toString()}');
      rethrow;
    }
  }

  Future createTrans(TransactionModel trans, ProductModel product) async {
    try{
      var setTrans = _db.collection(Constants.TRANSACTION);
      String transId = await setTrans.doc().id;

      setTrans.doc(transId).set({
        "buyerId": _auth.currentUser!.uid,
        "buyerLoc": trans.buyerLoc,
        "buyerName": trans.buyerName,
        "products": [
          {
            "productId": product.productId,
            "image": product.image,
            "name": product.name,
            "price": product.price,
          }
        ],
        "transactionId": transId,
        "storeImage": trans.storeImage,
        "storeName": trans.storeName,
        "orderDate": trans.orderDate,
        "rating": 0.0,
        "state": trans.state,
        "vendorId": trans.vendorId,
      });
    }catch(e){
      print('create trans: ${e.toString()}');
    }
  }

  Future updateTrans(String currentTransId, double rating, String state) async {
    var upTrans = _db.collection(Constants.TRANSACTION);
    await upTrans.doc(currentTransId).update({
      'rating': rating,
      'state': state
    });
  }

  Future<DocumentSnapshot> getVendor(String vendorId) async {
    return _db.collection(Constants.VENDOR).doc(vendorId).get();
  }

  Stream<QuerySnapshot> getVendorStream() {
    return _db.collection(Constants.VENDOR).snapshots();
  }

  Future<QuerySnapshot> getBanner() async {
    return _db.collection(Constants.BANNER).get();
  }

  Future<void> addReviews(Review review) async {
    return _db.collection('reviews').doc().set({
      "vendorId": review.vendorId,
      "buyerId": review.buyerId,
      "buyerName": review.buyerName,
      "rating": review.rating,
    });
  }

  Future<QuerySnapshot> getReviews(String vendorId) async {
    return _db.collection('reviews').where(Constants.VENDOR_ID_QUERY, isEqualTo: vendorId).get();
  }

}