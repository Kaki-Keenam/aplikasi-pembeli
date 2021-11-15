
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/models/product_model.dart';
import 'package:kakikeenam/app/data/models/transaction_model.dart';
import 'package:kakikeenam/app/data/models/user_model.dart';
import 'package:kakikeenam/app/data/models/vendor_model.dart';
import 'package:kakikeenam/app/data/provider/auth_remote.dart';
import 'package:kakikeenam/app/data/provider/db_remote.dart';

class RepositoryRemote{
  final AuthRemote _authRemote = Get.find<AuthRemote>();
  final DbRemote _dbRemote = Get.find<DbRemote>();


  Future<bool> get skipIntro => _authRemote.skipIntro();
  Future<bool> get autoLogin => _authRemote.autoLogin();

  Future<UserModel> get userModel => _dbRemote.getUserModel();

  Future<void> addToFirebase([String name = "User"]) {
    return _authRemote.addToFirebase(name);
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

  void editName(String name) {
    _dbRemote.editName(name);
  }

  void updatePhoto(String url) {
    _dbRemote.updatePhoto(url);
  }

  Stream<DocumentSnapshot> buyerLoc(){
    return _dbRemote.streamBuyerLoc();
  }

  Stream<QuerySnapshot> vendorId(GeoPoint lesserGeoPoint, GeoPoint greaterGeoPoint){
    return _dbRemote.vendorId(lesserGeoPoint, greaterGeoPoint);
  }

  Stream<QuerySnapshot> nearProduct(List<String> queryList){
    return _dbRemote.streamProduct(queryList);
  }

  Stream<QuerySnapshot> getProduct(String vendorId){
    return _dbRemote.getStreamData(vendorId);
  }

  Stream<DocumentSnapshot> streamListFavorite(){
    return _dbRemote.streamFavorite();
  }

  Stream<QuerySnapshot> streamListTrans(){
    return _dbRemote.streamTrans();
  }

  Future<QuerySnapshot> futureListTrans(){
    return _dbRemote.futureTrans();
  }

  void setTrans(TransactionModel trans, ProductModel product){
    _dbRemote.createTrans(trans, product);
  }

  Future updateTrans(String currentTransId, [String? state, double rating = 0.0]) async {
    await _dbRemote.updateTrans(currentTransId, rating, state!);
  }

  Future<VendorModel> getVendor(String vendorId) async{
    var vendor = await _dbRemote.getVendor(vendorId);
    var vendorModel = VendorModel.fromDocument(vendor);
    return vendorModel;
  }

  Future<QuerySnapshot> getBanner() async {
    return _dbRemote.getBanner();
  }

}