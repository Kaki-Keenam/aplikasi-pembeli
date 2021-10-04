
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kakikeenam/app/data/models/product_model.dart';
import 'package:response/response.dart';


class HomeController extends GetxController with SingleGetTickerProviderMixin {

  double degToRad(double angle){
    return -angle * (pi / 180);
  }

  AnimationController? _animationController;
  Animation<double>? _animation;
  Animation<Color>? _appBarTransAnimation;
  double minDragStartEdge = 60;

  bool canBeDragged = false;

  @override
  void onInit() {

    super.onInit();
  }



  // var currentIndex = 0.obs;
  // List<T> map<T>(List list, Function handler) {
  //   List<T> result = [];
  //   for (var i = 0; i < list.length; i++) {
  //     result.add(handler(i, list[i]));
  //   }
  //   return result.obs;
  // }

}
