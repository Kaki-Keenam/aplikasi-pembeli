import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  var isShowPassword = false.obs;
  var isShowConfirmPassword = false.obs;

  var nameC = TextEditingController();
  var emailC = TextEditingController();
  var passwordC = TextEditingController();
  var confirmPassC = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void onClose() {
    emailC.dispose();
    passwordC.dispose();
    nameC.dispose();
    confirmPassC.dispose();
    super.onClose();
  }
}
