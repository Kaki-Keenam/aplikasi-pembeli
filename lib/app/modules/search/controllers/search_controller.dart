import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  var searchC = TextEditingController();

  @override
  void onClose() {
    searchC.dispose();
    super.onClose();
  }
}
