import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class WelcomeController extends GetxController{
  var emailC = TextEditingController();
  var passC = TextEditingController();
  var nameC = TextEditingController();

  @override
  void dispose() {
    emailC.dispose();
    passC.dispose();
    nameC.dispose();
    super.dispose();
  }
}