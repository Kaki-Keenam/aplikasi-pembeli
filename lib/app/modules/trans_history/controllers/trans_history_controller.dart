import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/models/transaction_model.dart';
import 'package:kakikeenam/app/data/repository/repository_remote.dart';

class TransHistoryController extends GetxController {
  final RepositoryRemote _repositoryRemote = Get.find<RepositoryRemote>();
  var _transModel = RxList<TransactionModel>();
  List<TransactionModel>? get transaction => this._transModel;

  @override
  void onInit() {
    _transModel.bindStream(getTrans());
    super.onInit();
  }

  Stream<List<TransactionModel>> getTrans(){
    try{
      return _repositoryRemote.streamListTrans()
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
