import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/controllers/auth_controller.dart';

class LoginController extends GetxController {
  var isShowPassword = false.obs;
  var isShowIconButton = false.obs;

  var emailC = TextEditingController(text: "gonisetiawan0@gmail.com");
  var passwordC = TextEditingController(text: "sinagarendi");

  final formKey = GlobalKey<FormState>();
  final authC = Get.find<AuthController>();

  @override
  void onClose() {
    emailC.dispose();
    passwordC.dispose();
    authC.loading.value = false;
    super.onClose();
  }

}
