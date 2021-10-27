import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/controllers/auth_controller.dart';
import 'package:kakikeenam/app/data/models/product_model.dart';

import 'package:kakikeenam/app/modules/components/widgets/notify_dialogs.dart';
import 'package:kakikeenam/app/utils/constants/constants.dart';

class Transaction_state_controller extends GetxController {
  var dialogs = NotifyDialogs();
  FirebaseFirestore _dbStore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  // proposed
  Future<void> stateProposedTrans(ProductModel? food) async {
    var stringList =
        DateTime.now().toIso8601String().split(new RegExp(r"[T.]"));
    var formattedDate = "${stringList[0]} ${stringList[1]}.${stringList[2]}";
    try {
      String? buyerName = Get.find<AuthController>().userValue.name;
      CollectionReference trans = _dbStore.collection(Constants.TRANSACTION);
      CollectionReference vendor = _dbStore.collection(Constants.VENDOR);
      CollectionReference buyer = _dbStore.collection(Constants.BUYER);
      DocumentSnapshot buyerLoc =
          await buyer.doc(_auth.currentUser!.uid).get();
      String transId = await trans.doc().id;
      DocumentSnapshot vendors = await vendor.doc(food?.vendorId).get();

      trans.doc(transId).set({
        "buyerId": _auth.currentUser!.uid,
        "buyerLoc": buyerLoc.get("lastLocation"),
        "buyerName": buyerName,
        "products": [
          {
            "productId": food?.productId,
            "image": food?.image,
            "name": food?.name,
            "price": food?.price,
            "quantity": 1,
            "totalPrice": 10000,
          }
        ],
        "transactionId": transId,
        "storeImage": vendors.get("storeImage"),
        "storeName": vendors.get("storeName"),
        "orderDate": formattedDate,
        "rating": 5,
        "state": "PROPOSED",
        "vendorId": food?.vendorId,
      });
      // dialogs.proposedDialog(func: () {
      //   stateCancelConfirm(transId);
      // });
    } catch (e) {
      print("transState service: ${e.toString()}");
    }
  }

  void stateCancelConfirm(String? transId) {
    try {
      var trans = _dbStore.collection(Constants.TRANSACTION);
      trans.doc(transId).update({
        "state": "CANCEL",
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
