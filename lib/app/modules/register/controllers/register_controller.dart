import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  var isShowPassword = false.obs;
  var isShowConfirmPassword = false.obs;

  var nameC = TextEditingController(text: "Budi Setiawan");
  var emailC = TextEditingController(text: "gonisetiawan0@gmail.com");
  var passwordC = TextEditingController(text: "sinagarendi");
  var confirmPassC = TextEditingController(text: "sinagarendi");

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
