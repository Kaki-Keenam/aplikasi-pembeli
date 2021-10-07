
import 'dart:async';

import 'package:get/get.dart';


class HomeController extends GetxController with SingleGetTickerProviderMixin {

  var currentIndex = 0.obs;
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result.obs;
  }

}
