import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  var emailC = TextEditingController();

  @override
  void onClose() {
    emailC.dispose();
    super.onClose();
  }
}
