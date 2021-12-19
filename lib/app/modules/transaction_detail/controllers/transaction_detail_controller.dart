import 'package:get/get.dart';
import 'package:kakikeenam/app/data/models/transaction_model.dart';
import 'package:kakikeenam/app/data/repository/repository_remote.dart';

class TransactionDetailController extends GetxController {
  final RepositoryRemote _repositoryRemote = Get.find<RepositoryRemote>();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  Stream<TransactionModel> detailTrans(String transId)  {
     return _repositoryRemote.detailTrans(transId).map((value) {
      return TransactionModel.fromDocument(value.data() as Map<String, dynamic>);
    });
  }

}
