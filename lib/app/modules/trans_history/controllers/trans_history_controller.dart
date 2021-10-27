import 'package:get/get.dart';
import 'package:kakikeenam/app/data/database/database.dart';
import 'package:kakikeenam/app/data/models/transaction_model.dart';

class TransHistoryController extends GetxController {
  Rxn<List<TransactionModel>> _transModel = Rxn<List<TransactionModel>>();
  List<TransactionModel>? get transaction => _transModel.value;

  @override
  void onInit() {
    _transModel.bindStream(Database().streamListTrans());
    super.onInit();
  }
}
