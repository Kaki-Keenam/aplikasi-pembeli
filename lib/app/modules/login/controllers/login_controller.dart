import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var isShowPassword = false.obs;
  var isShowIconButton = false.obs;

  var emailC = TextEditingController(text: "gonisetiawan0@gmail.com");
  var passwordC = TextEditingController(text: "sinagarendi");

  final formKey = GlobalKey<FormState>();

  @override
  void onClose() {
    emailC.dispose();
    passwordC.dispose();
    super.onClose();
  }

}
