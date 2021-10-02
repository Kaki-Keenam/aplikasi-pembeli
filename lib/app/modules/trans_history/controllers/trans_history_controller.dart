import 'package:get/get.dart';
import 'package:kakikeenam/app/data/database/database.dart';
import 'package:kakikeenam/app/data/models/transaction_model.dart';
import 'package:kakikeenam/app/modules/components/widgets/notify_dialogs.dart';

class TransHistoryController extends GetxController {
  var dialogs = NotifyDialogs();
  Rxn<List<TransactionModel>> _transModel = Rxn<List<TransactionModel>>();
  List<TransactionModel>? get transaction => _transModel.value;

  @override
  void onInit() {
    stateVendorArrived();
    _transModel.bindStream(Database().streamListTrans());
    super.onInit();
  }

  void stateVendorArrived(){
    try{
      transaction?.forEach((element) {
        if(element.state == "ARRIVED"){
          dialogs.arrivedDialog(
            func: (){},
          );
        }
      });
    }catch(e){
      print(e.toString());
    }
  }
}
