import 'package:get/get.dart';
import 'package:kakikeenam/app/data/models/transaction_model.dart';
import 'package:kakikeenam/app/data/repository/repository_remote.dart';

class TransHistoryController extends GetxController {
  final RepositoryRemote _repositoryRemote = Get.find<RepositoryRemote>();
  var _transModel = RxList<TransactionModel>();
  List<TransactionModel>? get transaction => _transModel;

  @override
  void onInit() {
    _transModel.bindStream(_repositoryRemote.streamListTrans());
    super.onInit();
  }
}
