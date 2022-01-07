import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/models/review_model.dart';
import 'package:kakikeenam/app/data/models/transaction_model.dart';
import 'package:kakikeenam/app/data/models/user_model.dart';
import 'package:kakikeenam/app/data/repository/repository_remote.dart';

class TransHistoryController extends GetxController {
  final RepositoryRemote _repositoryRemote = Get.find<RepositoryRemote>();
  var _transModel = RxList<TransactionModel>();
  List<TransactionModel>? get transaction => this._transModel;

  Rx<UserModel> _user = UserModel().obs;
  UserModel get user => this._user.value;

  RxDouble _rating = 0.0.obs;

  set setRating(double rating) => this._rating.value = rating;

  @override
  void onInit() {
    _transModel.bindStream(getTrans());
    super.onInit();

    _repositoryRemote.user.then((user) => _user(user));
  }

  Stream<List<TransactionModel>> getTrans(){
    try{
      return _repositoryRemote.streamListTrans()
          .map((QuerySnapshot query) {
        List<TransactionModel> listData = List.empty(growable: true);
        query.docs.forEach((data) {
          listData.add(TransactionModel.fromDocument(data.data() as Map<String, dynamic>));
        });
        return listData;
      });
    }catch(e){
      print('trans: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> delTrans(String id) async{
    return await _repositoryRemote.delTrans(id);
  }

  void feedBack(String? photoUrl, int index) {
  try{
    _repositoryRemote.futureListTrans().then((value) async {
      TransactionModel trans = TransactionModel.fromDocument(
          value.docs[index].data() as Map<String, dynamic>);
      var review = Review()
        ..vendorId = trans.vendorId
        ..buyerId = trans.buyerId
        ..buyerName = trans.buyerName
        ..buyerImage = photoUrl
        ..rating = _rating.value;
      _repositoryRemote.updateTrans(
          trans.transactionId!, _rating.value, true);
      _repositoryRemote.addReview(review);
    });
  }catch(e){
    print('error at transC' + e.toString());
  }
  }

}
