
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakikeenam/app/data/models/chat_model.dart';
import 'package:kakikeenam/app/data/models/chat_room_model.dart';
import 'package:kakikeenam/app/data/models/product_model.dart';
import 'package:kakikeenam/app/data/models/review_model.dart';
import 'package:kakikeenam/app/data/models/transaction_model.dart';
import 'package:kakikeenam/app/data/models/user_model.dart';
import 'package:kakikeenam/app/data/models/vendor_model.dart';
import 'package:kakikeenam/app/data/provider/auth_remote.dart';
import 'package:kakikeenam/app/data/provider/db_remote.dart';

class RepositoryRemote{
  final AuthRemote _authRemote = Get.find<AuthRemote>();
  final DbRemote _dbRemote = Get.find<DbRemote>();

  var isAuth = false.obs;
  var isSkipIntro = false.obs;

  Future<void> firsInitialized() async {
      skipIntro.then((value) => isSkipIntro.value = value);
      autoLogin.then((value) => isAuth.value = value);
  }

  Future<bool> get skipIntro => _authRemote.skipIntro();
  Future<bool> get autoLogin => _authRemote.autoLogin();
  GoogleSignIn get isSignGoogle => _authRemote.googleSignIn;

  Stream<UserModel> get userModel => _dbRemote.getUserModel();
  Future<UserModel> get user => _dbRemote.userModel();

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

  Stream<DocumentSnapshot> detailTrans(String transId) {
    return _dbRemote.detailTrans(transId);
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

  Stream<QuerySnapshot> getVendorStreamQuery() {
    return _dbRemote.getVendorStreamQuery();
  }
  Stream<DocumentSnapshot> getVendorStream(String vendorId) {
    return _dbRemote.getVendorStream(vendorId);
  }

  Future<QuerySnapshot> getBanner() async {
    return _dbRemote.getBanner();
  }

  Future<void> addReview(Review review) async {
    return await _dbRemote.addReviews(review);
  }

  Future<QuerySnapshot> getReviews(String vendorId) async {
    return _dbRemote.getReviews(vendorId);
  }

  Future<void> delTrans(String id) async{
    return _dbRemote.delTrans(id);
  }

  Stream<QuerySnapshot> getChats() {
    return _dbRemote.getChats();
  }

  Stream<QuerySnapshot> getChatRoom(String chatId) {
    return _dbRemote.getChatRoom(chatId);
  }

  Future sendChat(Chat chat, String chatC) async{
    return _dbRemote.sendChat(chat, chatC);
  }

  Future updateChat(Chat chat) async{
    return _dbRemote.updateChat(chat);
  }

  Stream<QuerySnapshot> getChatRoomBySender(Chat chat){
    return _dbRemote.getChatRoomBySender(chat);
  }

  Future updateUnread(ChatRoom? chatRoom, Chat chat) async{
    return _dbRemote.updateUnread(chatRoom, chat);
  }

  Future deleteChat(ChatRoom? chatRoom, Chat chat) async{
    _dbRemote.deleteChat(chatRoom, chat);
  }

  Stream<DocumentSnapshot> getSingleChat(String chatId) {
    return _dbRemote.getSingleChat(chatId);
  }
}