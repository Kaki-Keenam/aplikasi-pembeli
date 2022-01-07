import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kakikeenam/app/data/models/chat_model.dart';
import 'package:kakikeenam/app/data/models/chat_room_model.dart';
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

  Stream<DocumentSnapshot> detailTrans(String transId) {
      return _db.collection(Constants.TRANSACTION).doc(transId).snapshots();

  }

  Future createTrans(TransactionModel trans, ProductModel product) async {
    try{
      var setTrans = _db.collection(Constants.TRANSACTION);
      String transId = await setTrans.doc().id;

      await setTrans.doc(transId).set({
        "buyerId": _auth.currentUser!.uid,
        "buyerLoc": trans.buyerLoc,
        "buyerName": trans.buyerName,
        "products": [
          {
            "productId": product.productId,
            "image": product.image,
            "name": product.name,
            "price": product.price,
            "quantity": trans.quantity,
          }
        ],
        "transactionId": transId,
        "storeName": trans.storeName,
        "orderDate": trans.orderDate,
        "address": trans.address,
        "rating": 0.0,
        "isRated": trans.isRated,
        "totalPrice": trans.quantity! * product.price!,
        "state": trans.state,
        "vendorId": trans.vendorId,
      });
    }catch(e){
      print('create trans: ${e.toString()}');
    }
  }

  Future updateTrans(String currentTransId, double rating, bool isRated) async {
    var upTrans = _db.collection(Constants.TRANSACTION);
    await upTrans.doc(currentTransId).update({
      'rating': rating,
      'isRated': isRated,
    });
  }

  Future<DocumentSnapshot> getVendor(String vendorId) async {
    return _db.collection(Constants.VENDOR).doc(vendorId).get();
  }

  Stream<QuerySnapshot> getVendorStreamQuery() {
    return _db.collection(Constants.VENDOR).where(Constants.LAST_LOCATION, isNotEqualTo: GeoPoint(0.0, 0.0)) .snapshots();
  }
  Stream<DocumentSnapshot> getVendorStream(String vendorId) {
    return _db.collection(Constants.VENDOR).doc(vendorId).snapshots();
  }

  Future<QuerySnapshot> getBanner() async {
    return _db.collection(Constants.BANNER).get();
  }

  Future addReviews(Review review) async {
    var reviewId = await _db.collection(Constants.REVIEWS).doc().id;

    await _db.collection(Constants.REVIEWS).doc(reviewId).set({
      "vendorId": review.vendorId,
      "buyerId": review.buyerId,
      "buyerName": review.buyerName,
      "rating": review.rating,
      "reviewId": reviewId,
      "buyerImage": review.buyerImage ?? _auth.currentUser?.photoURL,
      "time": DateTime.now().toIso8601String(),
    });
  }

  Future<QuerySnapshot> getReviews(String vendorId) async {
    return _db.collection(Constants.REVIEWS).where(Constants.VENDOR_ID_QUERY, isEqualTo: vendorId).get();
  }

  Future<void> delTrans(String id) async{
    return _db.collection(Constants.TRANSACTION).doc(id).delete();
  }

  Stream<QuerySnapshot> getChats() {
    return _db.collection(Constants.CHAT).where("connections", arrayContainsAny: [_auth.currentUser?.uid]).orderBy("lastUpdate", descending: true).snapshots();
  }

  Stream<QuerySnapshot> getChatRoom(String chatId) {
    return _db.collection(Constants.CHAT).doc(chatId).collection("message").orderBy("time", descending: false).snapshots();
  }

  Stream<QuerySnapshot> getChatRoomBySender(Chat chat) {
    return _db.collection(Constants.CHAT).doc(chat.chatId).collection("message").where("pengirim", isEqualTo: chat.connection?[0]).snapshots();
  }

  Future sendChat(Chat chat, String chatC) async {
    String messageId = await _db.collection(Constants.CHAT).doc(chat.chatId).collection("message").doc().id;
    return _db.collection(Constants.CHAT).doc(chat.chatId).collection("message").doc(messageId).set({
      "messageId" : messageId,
      "isRead" : false,
      "pengirim": chat.connection?[1],
      "penerima": chat.connection?[0],
      "pesan": chatC,
      "time": Timestamp.now(),
    });
  }

  Future updateChat(Chat chat) async{
    return _db.collection(Constants.CHAT).doc(chat.chatId).update({
      "lastUpdate" : Timestamp.now()
    });
  }

  Future updateUnread(ChatRoom? chatRoom, Chat chat) async{
    _db.collection(Constants.CHAT).doc(chat.chatId).collection("message").doc(chatRoom?.messageId).update({
      "isRead": true
    });
  }

  Future deleteChat(ChatRoom? chatRoom, Chat chat) async {
    _db.collection(Constants.CHAT).doc(chat.chatId).collection("message").doc(chatRoom?.messageId).delete();
  }

  Stream<DocumentSnapshot> getSingleChat(String chatId) {
    return _db.collection(Constants.CHAT).doc(chatId).snapshots();
  }
}