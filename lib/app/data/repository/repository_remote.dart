
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/models/product_model.dart';
import 'package:kakikeenam/app/data/models/transaction_model.dart';
import 'package:kakikeenam/app/data/models/user_model.dart';
import 'package:kakikeenam/app/data/models/vendor_model.dart';
import 'package:kakikeenam/app/data/provider/auth_remote.dart';
import 'package:kakikeenam/app/data/provider/db_remote.dart';
import 'package:kakikeenam/app/utils/constants/constants.dart';

class RepositoryRemote{
  final AuthRemote _authRemote = Get.find<AuthRemote>();
  final DbRemote _dbRemote = Get.find<DbRemote>();
  FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<UserModel> get userModel => _dbRemote.getUserModel();

  Future<void> addToFirebase([String name = "User"]) {
    return _authRemote.addToFirebase(name);
  }

  Future<bool> autoLogin() {
    return _authRemote.autoLogin();
  }

  Future<void> loginAuth(String email, String password) {
    return _authRemote.loginAuth(email, password);
  }

  Future<void> loginWithGoogle() {
    return _authRemote.loginWithGoogle();
  }

  Future<void> logout() {
    return _authRemote.logout();
  }

  Future<void> registerAuth(String email, String password, String name) {
    return _authRemote.registerAuth(email, password, name);
  }

  void resetPassword(String email) {
    return _authRemote.resetPassword(email);
  }

  Future<bool> skipIntro() {
    return _authRemote.skipIntro();
  }

  void editName(String name) {
    _dbRemote.editName(name);
  }

  void updatePhoto(String url) {
    _dbRemote.updatePhoto(url);
  }

  Stream<Stream<List<VendorModel>>> getStreamVendorId(){
    return _dbRemote.streamBuyerLoc().map((loc) {
      var location = loc.get('lastLocation');
      return streamVendorId(location);
    });
  }

  Stream<GeoPoint> buyerLoc(){
    return _dbRemote.streamBuyerLoc().map((DocumentSnapshot doc){
      var location = doc.get('lastLocation');
      return location;
    });
  }

  Stream<List<VendorModel>> streamVendorId(GeoPoint location) {
    try {
      double lowerLat =
          location.latitude - (Constants.LAT * Constants.DISTANCE_MILE);
      double lowerLong =
          location.longitude - (Constants.LONG * Constants.DISTANCE_MILE);

      double greaterLat =
          location.latitude + (Constants.LAT * Constants.DISTANCE_MILE);
      double greaterLong =
          location.longitude + (Constants.LONG * Constants.DISTANCE_MILE);

      GeoPoint lesserGeoPoint = GeoPoint(lowerLat, lowerLong);
      GeoPoint greaterGeoPoint = GeoPoint(greaterLat, greaterLong);
      return _db
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
              uid: data['uid'],
          ));
        });
        return listData;
      });
    } catch (e) {
      print("vendor service: ${e.toString()}");
      rethrow;
    }
  }

  Stream<List<ProductModel>> getProduct(String vendorId){
    try{
      return _dbRemote.getStreamData(vendorId).map((QuerySnapshot query) {
        List<ProductModel> listData = List.empty(growable: true);
        query.docs.forEach((element) {
          listData.add(ProductModel.fromDocument(element));
        });
        return listData;
      });
    }catch(e){
      print('vendorId: ${e.toString()}');
      rethrow;
    }
  }

  Stream<List<ProductModel>> streamListFavorite(){
    try{
      return _dbRemote.streamFavorite().map((DocumentSnapshot doc) {
        var fav = doc.data() as dynamic;
        var data = fav["favorites"];
        List<ProductModel> listData = List.empty(growable: true);
        data.forEach((element) {
          listData.add(ProductModel.fromMap(element));
        });
        return listData;
      });
    }catch(e){
      print('favorite: ${e.toString()}');
      rethrow;
    }
  }

  Stream<List<TransactionModel>> streamListTrans(){
    try{
      return _dbRemote.streamTrans()
          .map((QuerySnapshot query) {
        List<TransactionModel> listData = List.empty(growable: true);
        query.docs.forEach((element) {
          listData.add(TransactionModel.fromDocument(element));
        });
        return listData;
      });
    }catch(e){
      print('trans: ${e.toString()}');
      rethrow;
    }
  }

}